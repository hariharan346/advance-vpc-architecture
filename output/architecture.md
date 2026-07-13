# Mini Enterprise AWS Infrastructure Architecture

This document describes the design and components of the production and development environments.

## Network Topology

```
                         Internet
                             │
                     Internet Gateway
                             │
             ┌───────────────┴────────────────┐
             │                                │
        Bastion Host                Application Load Balancer
                                              │
                                   ┌──────────┴──────────┐
                                   │                     │
                             App Server 1          App Server 2
                                   │                     │
                                   └──────────┬──────────┘
                                              │
                                        Database Server
```

## IP Addressing Plan

### Production VPC (`10.0.0.0/16`)
* **Subnets**:
  * Public Subnets: `10.0.1.0/24`, `10.0.2.0/24` (Hosts Bastion and ALB)
  * Private App Subnets: `10.0.11.0/24`, `10.0.12.0/24` (Hosts App Server 1 and 2)
  * Private DB Subnet: `10.0.21.0/24` (Hosts Database Server)
* **Instances**:
  * Bastion Host: `10.0.1.79` (Public IP: `13.201.0.208`)
  * App Server 1: `10.0.11.81`
  * App Server 2: `10.0.12.161`
  * DB Server: `10.0.21.155`

### Development VPC (`10.1.0.0/16`)
* **Subnets**:
  * Public Subnet: `10.1.1.0/24` (Hosts Dev Server and Tools Server)
  * Private Subnet: `10.1.11.0/24`
* **Instances**:
  * Dev Server: `10.1.1.128` (Public IP: `13.234.48.120`)
  * Tools Server: `10.1.1.190` (Public IP: `13.234.33.226`)

## VPC Peering
* **Connection ID**: `pcx-0680b7bbd42fc9c02`
* **Purpose**: Provides secure, direct routing between the Production (`10.0.0.0/16`) and Development (`10.1.0.0/16`) address spaces.
