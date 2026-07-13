# 🔍 Network Audit Report

Comprehensive network diagnostics report covering the VPC Peering communication check.

## 1. Executive Summary
* **Issue**: Traffic between Development VPC (`10.1.0.0/16`) and Production VPC (`10.0.0.0/16`) timed out.
* **Root Cause**: The Dev VPC Route Table had an invalid route entry `0.0.0.0/16` targeting the VPC Peering connection instead of `10.0.0.0/16`.
* **Resolution**: Replaced the invalid route with the correct target range and authorized ICMP traffic in Security Groups.

## 2. Audited Checkpoints

| Audit Layer | Expected State | Checked State | Status | Resolution |
| :--- | :--- | :--- | :--- | :--- |
| **VPC Peering** | Active connection state | `active` | Green | None required |
| **Dev VPC Routes** | `10.0.0.0/16` $\rightarrow$ `pcx-0680b7bbd42fc9c02` | `0.0.0.0/16` $\rightarrow$ peering | Red | Replaced route entry |
| **Prod VPC Routes** | `10.1.0.0/16` $\rightarrow$ `pcx-0680b7bbd42fc9c02` | Missing in public RT | Red | Added route to public RT |
| **Subnet Assocs** | Correct table mappings | All mapped properly | Green | None required |
| **Security Groups** | Port 80 and ICMP allowed | ICMP blocked | Red | Authorized ICMP ingress |
| **NACLs** | Allow all traffic | Default allow-all | Green | None required |
| **OS Firewalls** | None blocking traffic | No rules configured | Green | None required |
| **SELinux** | Permissive / Disabled | `permissive` | Green | None required |
| **Listen Ports** | Nginx on port 80 | Listening | Green | None required |
