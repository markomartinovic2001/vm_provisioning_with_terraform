#!/usr/bin/env python3
import json
import sys

input_data = json.load(sys.stdin)

start = int(input_data.get("start", 11))
end = int(input_data.get("end", 49))
network = input_data.get("network_prefix", "192.168.0")

used_ips = input_data.get("used_ips", [])

for i in range(start, end + 1):
    candidate = f"{network}.{i}"
    if candidate not in used_ips:
        print(json.dumps({"ip_address": candidate}))
        sys.exit(0)

print(json.dumps({"ip_address": None}))
sys.exit(1)
