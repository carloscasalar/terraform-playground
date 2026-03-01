# AWS terraform playground

Use `aws configure` to [configure the AWS connection](https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html#cli-authentication-user-configure-csv.titlecli-authentication-user-mfa).

Verify it is properly configured by executing `aws ec2 describe-instances`

Verify that tf files are valid `terraform validate`

## Infrastructure Architecture

```mermaid
graph TB
    INTERNET((Internet<br/>0.0.0.0/0))

    subgraph VPC["VPC<br/>(10.0.0.0/16)"]
        IGW["Internet Gateway<br/>igw"]

        RTB["Route Table<br/>rtb<br/>━━━━━━━━━━<br/>0.0.0.0/0 → IGW"]

        LB["Application Load Balancer<br/>lc-web-lb<br/>Port 80"]
        LB_SG["Security Group<br/>lb_sg<br/>━━━━━━━━━━<br/>Ingress: TCP/80"]

        TG["Target Group<br/>lc-web-lb-tg<br/>Port 80"]

        subgraph Subnet1["Subnet 1<br/>(10.0.0.0/24)<br/>AZ 0"]
            NGINX1["EC2 Instance - nginx1<br/>t3.micro<br/>NGINX Server"]
        end

        subgraph Subnet2["Subnet 2<br/>(10.0.1.0/24)<br/>AZ 1"]
            NGINX2["EC2 Instance - nginx2<br/>t3.micro<br/>NGINX Server"]
        end

        SG["Security Group<br/>nginx-sg<br/>━━━━━━━━━━<br/>Ingress: TCP/80<br/>Ingress: TCP/22<br/>Egress: All Traffic"]
    end

    INTERNET -->|HTTP Traffic<br/>:80| LB
    IGW -->|attached to| VPC
    RTB -->|associated with| Subnet1
    RTB -->|associated with| Subnet2
    LB -->|secured by| LB_SG
    LB -->|forwards to| TG
    TG -->|targets| NGINX1
    TG -->|targets| NGINX2
    NGINX1 -->|secured by| SG
    NGINX2 -->|secured by| SG

    style NGINX1 fill:#f9f,stroke:#333,stroke-width:2px
    style NGINX2 fill:#f9f,stroke:#333,stroke-width:2px
    style SG fill:#bbf,stroke:#333,stroke-width:2px
    style LB_SG fill:#bbf,stroke:#333,stroke-width:2px
    style IGW fill:#bfb,stroke:#333,stroke-width:2px
    style INTERNET fill:#fbb,stroke:#333,stroke-width:2px
    style VPC fill:#f0f0f0,stroke:#333,stroke-width:2px
    style Subnet1 fill:#ffffff,stroke:#333,stroke-width:1px
    style Subnet2 fill:#ffffff,stroke:#333,stroke-width:1px
    style RTB fill:#e6f3ff,stroke:#333,stroke-width:1px
    style LB fill:#e6f3ff,stroke:#333,stroke-width:1px
    style TG fill:#e6f3ff,stroke:#333,stroke-width:1px
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

### Debugging

You can execute dig to find out the dns in the output:
```sh
⬢ [Docker] ❯ dig ec2-13-60-19-147.eu-north-1.compute.amazonaws.com

; <<>> DiG 9.18.39-0ubuntu0.24.04.2-Ubuntu <<>> ec2-13-60-19-147.eu-north-1.compute.amazonaws.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 45996
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;ec2-13-60-19-147.eu-north-1.compute.amazonaws.com. IN A

;; ANSWER SECTION:
ec2-13-60-19-147.eu-north-1.compute.amazonaws.com. 0 IN A 13.60.19.147

;; Query time: 20 msec
;; SERVER: 192.168.5.2#53(192.168.5.2) (UDP)
;; WHEN: Sun Mar 01 10:37:33 UTC 2026
;; MSG SIZE  rcvd: 132
```

And you can also execute a curl:
```sh
⬢ [Docker] ❯ curl -v ec2-13-60-19-147.eu-north-1.compute.amazonaws.com
* Host ec2-13-60-19-147.eu-north-1.compute.amazonaws.com:80 was resolved.
* IPv6: (none)
* IPv4: 13.60.19.147
*   Trying 13.60.19.147:80...
* connect to 13.60.19.147 port 80 from 172.17.0.2 port 50532 failed: Connection refused
* Failed to connect to ec2-13-60-19-147.eu-north-1.compute.amazonaws.com port 80 after 68 ms: Couldn't connect to server
* Closing connection
curl: (7) Failed to connect to ec2-13-60-19-147.eu-north-1.compute.amazonaws.com port 80 after 68 ms: Couldn't connect to server
```

If 22 port is enabled you can run a console inside one of the instances and verify the status of the nginx:
```sh
   ,     #_
   ~\_  ####_        Amazon Linux 2
  ~~  \_#####\
  ~~     \###|       AL2 End of Life is 2026-06-30.
  ~~       \#/ ___
   ~~       V~' '->
    ~~~         /    A newer version of Amazon Linux is available!
      ~~._.   _/
         _/ _/       Amazon Linux 2023, GA and supported until 2028-03-15.
       _/m/'           https://aws.amazon.com/linux/amazon-linux-2023/

[ec2-user@ip-10-0-1-86 ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Sun 2026-03-01 12:33:02 UTC; 12min ago
  Process: 2462 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 2458 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 2457 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 2464 (nginx)
   CGroup: /system.slice/nginx.service
           ├─2464 nginx: master process /usr/sbin/nginx
           ├─2465 nginx: worker process
           └─2466 nginx: worker process

Mar 01 12:33:02 ip-10-0-1-86.eu-north-1.compute.internal systemd[1]: Starting The nginx HTTP and reverse proxy server...
Mar 01 12:33:02 ip-10-0-1-86.eu-north-1.compute.internal nginx[2458]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Mar 01 12:33:02 ip-10-0-1-86.eu-north-1.compute.internal nginx[2458]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Mar 01 12:33:02 ip-10-0-1-86.eu-north-1.compute.internal systemd[1]: Started The nginx HTTP and reverse proxy server.
```
Then with a `curl localhost` you can check it is up and running (just in case you cannot access from your own terminal due to a wrong tf config).
