#!/usr/bin/env python3
import json
import requests

PROXMOX_URL = "https://<PROXMOX_HOST>:8006/api2/json"
API_TOKEN = "<YOUR_PROXMOX_API_TOKEN>"
NODE_NAME = "proxmox"

headers = {
    "Authorization": f"PVEAPIToken={API_TOKEN}"
}

vms = requests.get(f"{PROXMOX_URL}/nodes/{NODE_NAME}/qemu", headers=headers, verify=False).json()
lxcs = requests.get(f"{PROXMOX_URL}/nodes/{NODE_NAME}/lxc", headers=headers, verify=False).json()

used_ips = []

for vm in vms.get("data", []):
    ci = vm.get("ipconfig0", "")
    if ci and "ip=" in ci:
        ip = ci.split("ip=")[1].split("/")[0]
        used_ips.append(ip)

for c in lxcs.get("data", []):
    ci = c.get("ipconfig0", "")
    if ci and "ip=" in ci:
        ip = ci.split("ip=")[1].split("/")[0]
        used_ips.append(ip)

used_ips_str = ",".join(used_ips)

print(json.dumps({"used_ips": used_ips_str}))
