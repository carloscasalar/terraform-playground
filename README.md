# AWS terraform playground

Use `aws configure` to [configure the AWS connection](https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html#cli-authentication-user-configure-csv.titlecli-authentication-user-mfa).

Verify it is properly configured by executing `aws ec2 describe-instances`

## Infrastructure Architecture

```mermaid
graph TB
    subgraph VPC["VPC<br/>(10.0.0.0/16)"]
        subgraph Subnet["Subnet<br/>(10.0.0.0/24)"]
            NGINX["EC2 Instance - nginx1<br/>t3.micro<br/>NGINX Server"]
        end
        
        SG["Security Group<br/>nginx-sg<br/>━━━━━━━━━━<br/>Ingress: TCP/80<br/>Egress: All Traffic"]
        RTB["Route Table<br/>rtb<br/>━━━━━━━━━━<br/>0.0.0.0/0 → IGW"]
    end

    IGW["Internet Gateway<br/>igw"]
    INTERNET((Internet<br/>0.0.0.0/0))

    IGW -->|attached to| VPC
    RTB -->|associated with| Subnet
    NGINX -->|secured by| SG
    IGW -->|receives| INTERNET
    INTERNET -->|HTTP Traffic<br/>:80| NGINX

    style NGINX fill:#f9f,stroke:#333,stroke-width:2px
    style SG fill:#bbf,stroke:#333,stroke-width:2px
    style IGW fill:#bfb,stroke:#333,stroke-width:2px
    style INTERNET fill:#fbb,stroke:#333,stroke-width:2px
    style VPC fill:#f0f0f0,stroke:#333,stroke-width:2px
    style Subnet fill:#ffffff,stroke:#333,stroke-width:1px
    style RTB fill:#e6f3ff,stroke:#333,stroke-width:1px
```
## Configure
Create a file named `terraform.tfvars` with this content:
```tfvars
aws_access_key = "YOUR-ACCESS-KEY"
aws_secret_key = "YOUR-SECRET-KEY"
```

Or export them as env vars:
```env
TF_VAR_aws_access_key = "YOUR-ACCESS-KEY"
TF_VAR_aws_secret_key = "YOUR-SECRET-KEY"
```

You can also customize variables by passing them as `-var` to the terraform cli:
```sh
terraform plan \
  -var=billing_code="F0000" \
  -var=project="my-web"
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
