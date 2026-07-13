# Troubleshooting and Engineering Learning Notes

This document captures important engineering takeaways and lessons learned during the network resolution process.

## Key Learnings

### 1. VPC Route Typo Diagnostics
* **Scenario**: A route intended for `10.0.0.0/16` was accidentally set as `0.0.0.0/16`.
* **Lesson**: A `0.0.0.0/16` route matches IP addresses in the range `0.0.0.0` - `0.0.255.255`. Since our actual target address `10.0.11.81` falls outside this range, the routing logic defaults to the `0.0.0.0/0` (Internet Gateway) path, blackholing traffic meant for the private peering connection.
* **Best Practice**: Always double-check IP octets when adding routes. In Terraform, use automated CIDR helpers or variables to avoid human typos.

### 2. Windows Carriage Returns (\r\n) in UserData Bash Scripts
* **Scenario**: The UserData script failed because the Windows CLI uploaded the multiline script with CRLF line endings.
* **Lesson**: Bash interpreters fail to run scripts with CRLF line endings because they parse `\r` as part of the command (e.g., `/bin/bash^M: bad interpreter`).
* **Best Practice**: Ensure user-data inputs are normalized to LF (`\n`) before encoding to Base64, or use config-management tools (like Ansible) or execute commands over SSH.

### 3. Stateful Security Groups
* **Scenario**: App Servers are in a private subnet, but can initiate connections and receive responses automatically.
* **Lesson**: AWS Security Groups are stateful. When an instance initiates an outbound connection, response traffic is automatically allowed, regardless of inbound rules. 
