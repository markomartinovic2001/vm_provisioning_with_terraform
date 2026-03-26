terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.80.0"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://<PROXMOX_HOST>:8006/"
  api_token = "<YOUR_PROXMOX_API_TOKEN>"
  insecure  = true
}

data "external" "fetch_used_ips" {
  program = ["python3", "${path.module}/fetch_used_ips.py"]
}

data "external" "next_ip" {
  program = ["python3", "${path.module}/next_ip.py"]

  query = {
    start          = var.ip_range_start
    end            = var.ip_range_end
    network_prefix = var.network_prefix
    used_ips       = data.external.fetch_used_ips.result["used_ips"]
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.vm_name
  node_name = "proxmox"
  vm_id     = var.vm_id

  clone {
    vm_id = var.vm_template_id
    full  = true
  }

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory_mb
  }

  network_device {
    bridge = "vmbr0"
  }

  agent {
    enabled = false
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${data.external.next_ip.result["ip_address"]}/24"
        gateway = "192.168.0.1"
      }
    }
  }
}
