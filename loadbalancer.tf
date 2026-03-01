## aws_lb
# This is an application load balancer to distribute trafic between the instances
# https://registry.terraform.io/providers/-/aws/latest/docs/resources/lb
resource "aws_lb" "nginx_lb" {
  name               = "lc-web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  enable_deletion_protection = false

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.id
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

  tags = local.common_tags
}

## aws_lb_listener
# The listner tells where is the load balancer listening
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "nginx" {
  # Requires the amazon resource name
  load_balancer_arn = aws_lb.nginx_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}

## aws_target_group
# This is the target group where the traffic will be forwarded
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "nginx_tg" {
  name     = "lc-web-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}


## aws_lb_target_group
# https://registry.terraform.io/providers/-/aws/latest/docs/resources/lb_target_group_attachment
resource "aws_lb_target_group_attachment" "nginx1_tga" {
  target_group_arn = aws_lb_target_group.nginx_tg.arn
  target_id        = aws_instance.nginx1.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "nginx2_tga" {
  target_group_arn = aws_lb_target_group.nginx_tg.arn
  target_id        = aws_instance.nginx2.id
  port             = 80
}
