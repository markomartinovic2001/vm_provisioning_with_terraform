# **Proxmox VM Provisioning with Terraform**

This repository contains scripts and Terraform configuration for automating VM creation on a **Proxmox** server, including automatic IP assignment.

---

## **Features**

- **Fetches all used IPs** on the Proxmox node (both QEMU VMs and LXC containers).  
- **Automatically selects the next free IP** in a specified range.  
- **Clones a VM from a template** and applies CPU, memory, and network configuration.  
- **Fully Terraform-managed deployment.**

---

## **Files**

| **File** | **Description** |
|----------|-----------------|
| `fetch_used_ips.py` | Python script to query Proxmox for all used IP addresses. |
| `next_ip.py` | Python script to find the next free IP in the range. |
| `main.tf` | Terraform configuration for provisioning a VM. |
| `variables.tf` | Terraform variable definitions. |

---

## **Prerequisites**

- **Terraform** >= 1.5.0  
- **Python 3** with `requests` library  
- Proxmox API token with sufficient permissions  
- Root access to a Proxmox node

---

## **Setup**

1. **Clone this repository**

  git clone repo-url

  cd repo-directory

After `cd <repo-directory>`, everything below is inside this block

-------------------------------
# Step 1: Update Proxmox credentials
-------------------------------
Edit fetch_used_ips.py and main.tf and replace:

fetch_used_ips.py
PROXMOX_URL = "https://<PROXMOX_HOST>:8006/api2/json"
API_TOKEN = "<YOUR_PROXMOX_API_TOKEN>"

# main.tf provider block
provider "proxmox" {
  endpoint  = "https://<PROXMOX_HOST>:8006/"
  api_token = "<YOUR_PROXMOX_API_TOKEN>"
  insecure  = true
}

⚠️ Never commit your real API token or credentials to a public repository. ⚠️

-------------------------------
# Step 2: Configure VM variables
-------------------------------
Edit variables.tf or provide values during terraform apply:

vm_name         = "terraform-test"
vm_id           = 105
cpu_cores       = 1
memory_mb       = 1024
vm_template_id  = 104
ip_range_start  = 11
ip_range_end    = 49
network_prefix  = "192.168.0"

-------------------------------
# Step 3: Fetch used IPs
-------------------------------
python3 fetch_used_ips.py

Example output:
{"used_ips": ["192.168.0.11", "192.168.0.12", "192.168.0.13"]}

-------------------------------
# Step 4: Determine the next free IP
-------------------------------
cat <<EOF | python3 next_ip.py
{
  "start": 11,
  "end": 49,
  "network_prefix": "192.168.0",
  "used_ips": ["192.168.0.11","192.168.0.12","192.168.0.13"]
}
EOF

Example output:
{"ip_address": "192.168.0.14"}

-------------------------------
# Step 5: Provision the VM with Terraform
-------------------------------
terraform init
terraform plan
terraform apply

Terraform will:
  - Fetch used IPs from Proxmox
  - Determine the next free IP
  - Clone the VM from the template
  - Configure CPU, memory, and network
  - Assign the IP address to the new VM

 Notes:
 - IPs are assigned sequentially from ip_range_start to ip_range_end.
 - Make sure the Proxmox API token has permissions for VM read, clone, and network configuration.
 - The scripts currently ignore SSL verification (verify=False) – for production, provide valid certificates.
