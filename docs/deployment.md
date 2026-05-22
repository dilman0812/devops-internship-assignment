# Deployment Steps

1. Create VPC

CIDR:

10.0.0.0/16

2. Create Public Subnet

10.0.1.0/24

3. Create Private Subnet

10.0.2.0/24

4. Attach Internet Gateway

5. Configure Route Tables

Public:

0.0.0.0/0 → IGW

Private:

Local only

6. Launch API VM

Public subnet

7. Launch Inference VM

Private subnet

8. Configure security groups

Allow:

3111 HTTP

49134 RPC

SSH only where required

9. Deploy quickstart workers

10. Validate RPC communication
