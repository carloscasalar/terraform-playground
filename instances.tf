# INSTANCES #
resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]

  # force_destroy = true

  user_data = <<EOF
#!/bin/bash
# Install nginx using amazon extras
sudo amazon-linux-extras install -y nginx1

# Start NGINX service
sudo service nginx start

# Enable NGINX to start on boot
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Lemon Land Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
  EOF

  tags = local.common_tags
}

resource "aws_instance" "nginx2" {
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.subnet2.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]

  # force_destroy = true

  user_data = <<EOF
#!/bin/bash
# Install nginx using amazon extras
sudo amazon-linux-extras install -y nginx1

# Start NGINX service
sudo service nginx start

# Enable NGINX to start on boot
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Lemon Land Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
  EOF

  tags = local.common_tags
}
