## AWS Resource Flow Diagram (Text Representation)

```
aws_vpc
   │
   ├──▶ aws_subnet ──▶ aws_instance
   ├──▶ aws_internet_gateway
   ├──▶ aws_security_group
   └──▶ aws_route_table ──▶ aws_route_table_association ──▶ aws_subnet
```

# ✅ Detailed Explanation of Each Resource

### 1. `provider "aws"`
- **Why**: Defines the AWS region and credentials for all resources.
- **Connection**: Required to initialize Terraform for AWS.

---

### 2. `aws_vpc` (Virtual Private Cloud)
- **Why**: Creates an isolated network in AWS where you can launch resources.
- **Connection**:
  - All resources (subnet, internet gateway, route table, security group, EC2) are within this VPC.
  - Acts as the foundation of your cloud network.

---

### 3. `aws_subnet`
- **Why**: Subdivides the VPC into smaller IP ranges and enables EC2 instance placement.
- **Connection**:
  - Attached to `aws_vpc` using `vpc_id`.
  - Linked to EC2 using `subnet_id`.
  - Linked to a Route Table using `aws_route_table_association`.

---

### 4. `aws_internet_gateway`
- **Why**: Enables internet access to the VPC (and hence the EC2).
- **Connection**:
  - Attached to the VPC using `vpc_id`.
  - Used in `aws_route_table` to route `0.0.0.0/0` to the internet.

---

### 5. `aws_route_table`
- **Why**: Tells the subnet how to route traffic. In this case, it routes external (internet) traffic through the Internet Gateway.
- **Connection**:
  - Attached to VPC using `vpc_id`.
  - Contains a route with `gateway_id = aws_internet_gateway.gw.id`.

---

### 6. `aws_route_table_association`
- **Why**: Binds the route table to the subnet, making the route rules effective for the subnet.
- **Connection**:
  - Connects `aws_subnet` and `aws_route_table`.

---

### 7. `aws_security_group`
- **Why**: Acts as a virtual firewall for your EC2 instance.
- **Connection**:
  - Created inside the VPC.
  - Assigned to EC2 using `vpc_security_group_ids`.
  - Allows inbound SSH (port 22) and outbound traffic to anywhere.

---

### 8. `aws_instance`
- **Why**: Launches a virtual machine (EC2) inside AWS.
- **Connection**:
  - Placed in `aws_subnet` via `subnet_id`.
  - Uses the `aws_security_group` for traffic control.
  - Uses an AMI ID and `instance_type`.
  - Gets a public IP due to `associate_public_ip_address = true` and correct routing.

---

### 9. `variable "key_name"`
- **Why**: Accepts your existing AWS key pair name to allow SSH access into the EC2 instance.
- **Connection**:
  - Used in the EC2 resource with `key_name = var.key_name`.

---

### 10. `output "ec2_public_ip"`
- **Why**: Displays the public IP of the EC2 instance after deployment.
- **Connection**:
  - Extracts `aws_instance.my_ec2.public_ip`.

---

# 🔗 Summary of Flow

- **VPC** is created as the parent network.
- **Subnet** is created inside the VPC.
- **Internet Gateway** is attached to VPC to enable public access.
- **Route Table** is created in the VPC and linked to the gateway.
- **Route Table** is associated with the subnet.
- **Security Group** is defined to allow SSH access.
- **EC2 Instance** is launched:
  - Inside the subnet
  - With the security group
  - With a public IP for SSH access
