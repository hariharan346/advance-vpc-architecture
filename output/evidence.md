# Evidence of Successful Network Lab Implementation

This document serves as verification evidence for the successful troubleshooting and implementation of all stages.

## 1. VPC Route Verification

### Development VPC Route Entries
```json
[
    {
        "RouteTableId": "rtb-0f2511d3eff9c3340",
        "Routes": [
            {
                "DestinationCidrBlock": "10.0.0.0/16",
                "Origin": "CreateRoute",
                "State": "active",
                "VpcPeeringConnectionId": "pcx-0680b7bbd42fc9c02"
            },
            {
                "DestinationCidrBlock": "10.1.0.0/16",
                "GatewayId": "local",
                "Origin": "CreateRouteTable",
                "State": "active"
            },
            {
                "DestinationCidrBlock": "0.0.0.0/0",
                "GatewayId": "igw-08eabaef329912c4e",
                "Origin": "CreateRoute",
                "State": "active"
            }
        ]
    }
]
```

---

## 2. Nginx App Deployment Verification

### Load Balancer HTTP response headers
```http
HTTP/1.1 200 OK
Date: Mon, 13 Jul 2026 08:20:41 GMT
Content-Type: text/html
Content-Length: 917
Connection: keep-alive
Server: nginx/1.30.3
Last-Modified: Mon, 13 Jul 2026 08:18:59 GMT
ETag: "6a549f73-395"
Accept-Ranges: bytes
```

---

## 3. Tools Server Services Verification

### Docker Containers State
```
CONTAINER ID   IMAGE                 COMMAND                  CREATED          STATUS          PORTS                                                                                      NAMES
fa42d4bd475a   prom/prometheus       "/bin/prometheus --c…"   12 seconds ago   Up 10 seconds   0.0.0.0:9090->9090/tcp, :::9090->9090/tcp                                                  prometheus
581ba8dadf32   grafana/grafana       "/run.sh"                22 seconds ago   Up 20 seconds   0.0.0.0:3000->3000/tcp, :::3000->3000/tcp                                                  grafana
b0ff2c76d6c7   jenkins/jenkins:lts   "/usr/bin/tini -- /u…"   49 seconds ago   Up 48 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp, 0.0.0.0:50000->50000/tcp, :::50000->50000/tcp   jenkins
```
* **Jenkins Port 8080**: Active
* **Grafana Port 3000**: Active
* **Prometheus Port 9090**: Active
