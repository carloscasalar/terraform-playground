output "aws_instance_public_dns_nginx1" {
  value = aws_instance.nginx1.public_dns
}
output "aws_instance_public_dns_nginx2" {
  value = aws_instance.nginx2.public_dns
}
output "aws_lb_dns_name" {
  value       = aws_lb.nginx_lb.dns_name
  description = "The DNS name of the load balancer"
}
