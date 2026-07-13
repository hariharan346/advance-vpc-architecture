# Terraform Deployment Roadmap

This document outlines how to execute the Terraform files located in the `terraform/` directory to automatically provision the entire Mini Enterprise AWS Infrastructure.

## Deployment Steps

### 1. Prerequisites
* Install Terraform CLI (`>= 1.0.0`).
* Configure AWS Credentials in local terminal or environment variables:
  ```bash
  aws configure
  # Input your Access Key ID and Secret Access Key
  ```

### 2. Initialize Working Directory
Navigate to the `terraform/` directory and initialize provider dependencies:
```bash
cd terraform
terraform init
```

### 3. Review Plan
Generate and inspect the execution plan to verify all resources (VPCs, Subnets, Gateways, EC2s, ALBs) will be provisioned correctly:
```bash
terraform plan
```

### 4. Apply Infrastructure Changes
Provision the resources in your AWS account:
```bash
terraform apply -auto-approve
```

### 5. Verification after Terraform Run
Once deployment finishes:
* Note down the ALB DNS name printed or displayed in the AWS Console.
* Curl the ALB DNS name to verify HTTP traffic goes to the app servers.
* SSH into the `tools-server` and verify that Jenkins (8080), Grafana (3000), and Prometheus (9090) containers are running.
