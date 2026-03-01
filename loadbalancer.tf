## aws_lb
# https://registry.terraform.io/providers/-/aws/latest/docs/resources/lb
resource "aws_lb" "lc_web_lb" {
  name               = "lc_web_lb"
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

## aws_target_group

## aws_lb_target_group
