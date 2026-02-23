# AWS terraform playground

Use `aws configure` to [configure the AWS connection](https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html#cli-authentication-user-configure-csv.titlecli-authentication-user-mfa).

Verify it is properly configured by executing `aws ec2 describe-instances`

## Infrastructure Architecture

```mermaid
graph TB
    subgraph "VPC (10.0.0.0/16)"
        subgraph "Subnet (10.0.0.0/24)"
            NGINX[EC2 Instance - nginx1<br/>t2.micro<br/>NGINX Server]
        end

        SG[Security Group<br/>nginx-sg<br/>Ingress: HTTP:80<br/>Egress: All]
        RTB[Route Table<br/>rtb]
    end

    IGW[Internet Gateway<br/>igw]
    INTERNET((Internet<br/>0.0.0.0/0))

    IGW -->|attached to| VPC
    RTB -->|route 0.0.0.0/0| IGW
    RTB -.associates with.- Subnet
    NGINX -.uses.- SG
    INTERNET -->|HTTP Traffic| IGW

    style NGINX fill:#f9f,stroke:#333,stroke-width:2px
    style SG fill:#bbf,stroke:#333,stroke-width:2px
    style IGW fill:#bfb,stroke:#333,stroke-width:2px
    style INTERNET fill:#fbb,stroke:#333,stroke-width:2px
```
## Configure
Create a file named `terraform.tfvars` with this content:
```tfvars
aws_access_key = "YOUR-ACCESS-KEY"
aws_secret_key = "YOUR-SECRET-KEY"
```

## Deploy

Execute:
```bash
terraform init
terraform plan -out d1.tfplan
```

Review the plan then:
```bash
terraform apply d1.tfplan
```

Destroy all resurces:
```bash
terraform destroy
```
