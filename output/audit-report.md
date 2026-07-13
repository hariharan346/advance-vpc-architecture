# Network Audit Report

This report documents the comprehensive audit conducted on the Mini Enterprise AWS Infrastructure to diagnose and fix the VPC Peering connectivity issues.

## Audited Components and Findings

### 1. VPC Peering Configuration
* **Status**: Active.
* **Details**: Peering Connection `pcx-0680b7bbd42fc9c02` connects Production VPC (`vpc-036e5523462a585df`, CIDR `10.0.0.0/16`) and Development VPC (`vpc-0c25b9a04536680c6`, CIDR `10.1.0.0/16`).
* **Verification Command**:
  ```bash
  aws ec2 describe-vpc-peering-connections --region ap-south-1
  ```
* **Findings**: The VPC peering connection state was already `active`.

### 2. Route Tables on both VPCs
* **Status**: Misconfigured.
* **Verification Command**:
  ```bash
  aws ec2 describe-route-tables --region ap-south-1
  ```
* **Findings**:
  * **Development Route Table** (`rtb-0f2511d3eff9c3340`): Had an incorrect route `0.0.0.0/16` targeting the VPC Peering connection instead of `10.0.0.0/16`.
  * **Production Public Route Table** (`rtb-07ec2c413b6e042fd`): Missing the route to `10.1.0.0/16` via `pcx-0680b7bbd42fc9c02`.
* **Fix Applied**:
  * Deleted `0.0.0.0/16` route and added `10.0.0.0/16` -> `pcx-0680b7bbd42fc9c02` in Development VPC route table.
  * Added `10.1.0.0/16` -> `pcx-0680b7bbd42fc9c02` in Production Public route table.

### 3. Subnet Associations
* **Status**: Correct.
* **Verification Command**:
  ```bash
  aws ec2 describe-route-tables --region ap-south-1 --query "RouteTables[*].{RouteTableId:RouteTableId,Associations:Associations}"
  ```
* **Findings**: Subnets are correctly associated with public/private route tables.

### 4. Internet Gateway (IGW)
* **Status**: Correct.
* **Verification Command**:
  ```bash
  aws ec2 describe-internet-gateways --region ap-south-1
  ```
* **Findings**: IGWs exist and are attached to both VPCs.

### 5. NAT Gateway
* **Status**: Correct.
* **Verification Command**:
  ```bash
  aws ec2 describe-nat-gateways --region ap-south-1
  ```
* **Findings**: NAT Gateway `nat-00b57fe969d1e426c` exists in Prod Public subnet 1 and is healthy.

### 6. Network ACLs (NACLs)
* **Status**: Correct (Default Allow-All).
* **Verification Command**:
  ```bash
  aws ec2 describe-network-acls --region ap-south-1
  ```
* **Findings**: No custom NACLs block cross-VPC peering traffic.

### 7. Security Groups
* **Status**: Correct, but ICMP (ping) traffic was blocked.
* **Verification Command**:
  ```bash
  aws ec2 describe-security-groups --region ap-south-1
  ```
* **Fix Applied**:
  * Authorized ICMP inbound rules for `app-sg` and `dev-sg` to permit connectivity validation.

### 8. Instance ENIs
* **Status**: Correct.
* **Verification Command**:
  ```bash
  aws ec2 describe-network-interfaces --region ap-south-1
  ```

### 9. Source/Destination Check
* **Status**: Correct (Enabled, standard for non-NAT/VPN EC2 instances).
* **Verification Command**:
  ```bash
  aws ec2 describe-instance-attribute --instance-id <instance-id> --attribute sourceDestCheck --region ap-south-1
  ```

### 10. OS Firewalls (iptables/nftables)
* **Status**: Correct (No OS firewalls installed or active on Amazon Linux 2023).
* **Verification Command**:
  ```bash
  sudo iptables -L -n
  sudo nft list ruleset
  ```

### 11. SELinux
* **Status**: Correct (SELinux in `permissive` mode on all instances).
* **Verification Command**:
  ```bash
  sestatus
  ```

### 12. Listening Ports
* **Status**: Correct (Nginx listening on port 80, SSH on port 22).
* **Verification Command**:
  ```bash
  ss -tuln
  ```
