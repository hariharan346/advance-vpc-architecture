# Required Validation Screenshots

To provide visual proof of the working environment, capture and compile the following screenshots from the AWS Console and the local browser:

1. **VPC Peering Connection Status**
   * Navigate to: AWS Console -> VPC -> Peering connections.
   * Verify: `prod-dev-peer` status is `Active`.

2. **Development VPC Route Table**
   * Navigate to: AWS Console -> VPC -> Route tables -> Select `dev-rt`.
   * Verify: Route `10.0.0.0/16` targets `pcx-0680b7bbd42fc9c02`.

3. **Production VPC Private Route Table**
   * Navigate to: AWS Console -> VPC -> Route tables -> Select `prod-private-rt`.
   * Verify: Route `10.1.0.0/16` targets `pcx-0680b7bbd42fc9c02`.

4. **EC2 Instances Status**
   * Navigate to: AWS Console -> EC2 -> Instances.
   * Verify: All instances (`bastion-host`, `app-server-1`, `app-server-2`, `db-server`, `dev-server`, and `tools-server`) are in `running` state.

5. **Nginx Web Landing Page (ALB)**
   * Navigate to: `http://prod-alb-67643845.ap-south-1.elb.amazonaws.com` in a browser.
   * Verify: The custom landing page is rendered with status `SUCCESSFUL`.

6. **Jenkins Dashboard Access**
   * Navigate to: `http://13.234.33.226:8080` in a browser.
   * Verify: The Jenkins setup or login page is displayed.

7. **Grafana Dashboard Access**
   * Navigate to: `http://13.234.33.226:3000` in a browser.
   * Verify: The Grafana login page is displayed.

8. **Prometheus Targets Page**
   * Navigate to: `http://13.234.33.226:9090/targets` in a browser.
   * Verify: The Prometheus target status page is displayed.
