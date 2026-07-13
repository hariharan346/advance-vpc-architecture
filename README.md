# Enterprise AWS Mini Lab

A compact enterprise AWS networking and DevOps lab that demonstrates
real-world AWS networking, security, CI/CD, monitoring, and
Infrastructure as Code while keeping AWS costs low.

------------------------------------------------------------------------

# Architecture

``` text
                                        Internet
                                            │
                                    Internet Gateway
                                            │
                      ┌─────────────────────┴─────────────────────┐
                      │                                           │
                 Bastion Host                         Application Load Balancer
                (Public Subnet)                              (Public Subnet)
                                                                    │
                                            ┌───────────────────────┴───────────────────────┐
                                            │                                               │
                                     App Server 1                                   App Server 2
                                  (Private App Subnet A)                       (Private App Subnet B)
                                            │                                               │
                                            └───────────────────────┬───────────────────────┘
                                                                    │
                                                             Database Server
                                                           (Private DB Subnet)

═══════════════════════════════════════════════════════════════════════════════════════

                    Production VPC (10.0.0.0/16)

Public Subnet
-------------
• Bastion Host
• Application Load Balancer
• NAT Gateway
• Tools Server
  ├── Docker
  ├── Jenkins
  ├── Prometheus
  └── Grafana

Private App Subnets
-------------------
• App Server 1
• App Server 2

Private DB Subnet
-----------------
• Database Server

═══════════════════════════════════════════════════════════════════════════════════════

                           VPC Peering

═══════════════════════════════════════════════════════════════════════════════════════

                  Development VPC (10.1.0.0/16)

Public Subnet
-------------
• Development Server

═══════════════════════════════════════════════════════════════════════════════════════

                          CI/CD Pipeline

Developer
     │
 GitHub
     │
GitHub Actions
     │
Deploy
     │
App Server 1 & App Server 2

═══════════════════════════════════════════════════════════════════════════════════════

                   Infrastructure as Code

Terraform
     │
Provision
     │
Entire AWS Infrastructure
```

------------------------------------------------------------------------

# Project Roadmap

## ✅ Phase 1 -- Production Environment

-   Production VPC
-   Public & Private Subnets
-   Internet Gateway
-   NAT Gateway
-   Route Tables
-   Security Groups
-   Bastion Host
-   App Server 1
-   App Server 2
-   Database Server
-   Application Load Balancer
-   Target Group

------------------------------------------------------------------------

## 🔄 Phase 2 -- Development Environment

-   Development VPC
-   Development Server
-   VPC Peering
-   Connectivity Validation

------------------------------------------------------------------------

## ⏳ Phase 3 -- Tools Server

Deploy one EC2 and install:

-   Docker
-   Jenkins
-   Prometheus
-   Grafana

------------------------------------------------------------------------

## ⏳ Phase 4 -- CI/CD

``` text
Developer
    │
 GitHub
    │
GitHub Actions
    │
Deploy
    │
Production App Servers
```

------------------------------------------------------------------------

## ⏳ Phase 5 -- Terraform

Provision the complete infrastructure using Terraform:

-   VPC
-   Subnets
-   Internet Gateway
-   NAT Gateway
-   Route Tables
-   Security Groups
-   EC2
-   ALB
-   Target Group

------------------------------------------------------------------------

# Technologies

-   AWS VPC
-   EC2
-   ALB
-   Security Groups
-   NAT Gateway
-   Internet Gateway
-   VPC Peering
-   Docker
-   Jenkins
-   Prometheus
-   Grafana
-   GitHub Actions
-   Terraform

------------------------------------------------------------------------

# Learning Outcomes

-   Enterprise VPC Design
-   Three-Tier Architecture
-   Multi-VPC Networking
-   Secure Remote Administration
-   Load Balancing
-   DevOps Tooling
-   CI/CD Automation
-   Infrastructure as Code
