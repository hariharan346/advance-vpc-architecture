# Executed Commands Reference

This is a comprehensive reference of all AWS CLI and Linux shell commands executed to troubleshoot, verify, and implement the project stages.

## AWS CLI Verification Commands

### Describe Caller Identity
```bash
aws sts get-caller-identity
```

### Describe VPCs
```bash
aws ec2 describe-vpcs --region ap-south-1 --query "Vpcs[*].{VpcId:VpcId,CidrBlock:CidrBlock,Tags:Tags}" --output json
```

### Describe VPC Peering Connections
```bash
aws ec2 describe-vpc-peering-connections --region ap-south-1
```

### Describe Subnets
```bash
aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-0c25b9a04536680c6" --region ap-south-1
```

### Describe Route Tables
```bash
aws ec2 describe-route-tables --region ap-south-1 --query "RouteTables[*].{RouteTableId:RouteTableId,Routes:Routes}"
```

### Describe Security Groups
```bash
aws ec2 describe-security-groups --region ap-south-1
```

---

## AWS CLI Remediation/Fix Commands

### Delete Misconfigured Route in Dev VPC Route Table
```bash
aws ec2 delete-route --route-table-id rtb-0f2511d3eff9c3340 --destination-cidr-block 0.0.0.0/16 --region ap-south-1
```

### Add Correct Route in Dev VPC Route Table
```bash
aws ec2 create-route --route-table-id rtb-0f2511d3eff9c3340 --destination-cidr-block 10.0.0.0/16 --vpc-peering-connection-id pcx-0680b7bbd42fc9c02 --region ap-south-1
```

### Add Route in Prod VPC Public Route Table
```bash
aws ec2 create-route --route-table-id rtb-07ec2c413b6e042fd --destination-cidr-block 10.1.0.0/16 --vpc-peering-connection-id pcx-0680b7bbd42fc9c02 --region ap-south-1
```

### Authorize Security Group Ingress for ICMP
```bash
aws ec2 authorize-security-group-ingress --group-id sg-01628f668a727aac5 --protocol icmp --port -1 --cidr 10.1.0.0/16 --region ap-south-1
aws ec2 authorize-security-group-ingress --group-id sg-0f681afa55fbad568 --protocol icmp --port -1 --cidr 10.0.0.0/16 --region ap-south-1
```

---

## Linux/SSH Commands

### Check Open Ports
```bash
ss -tuln
```

### Check SELinux Status
```bash
sestatus
```

### Test Connectivity
```bash
ping -c 3 10.0.11.81
curl -I http://10.0.11.81
```

### Run Tools Containers (Docker)
```bash
docker run -d -p 8080:8080 -p 50000:50000 --name jenkins --restart always -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
docker run -d -p 3000:3000 --name grafana --restart always grafana/grafana
docker run -d -p 9090:9090 --name prometheus --restart always -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
```
