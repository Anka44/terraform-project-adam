output "app_server_ip" {
  value = aws_instance.app_server.public_ip
}

output "app_server_id" {
  value = aws_instance.app_server.id
}

output "lb_dns_name1" {
  value = aws_lb.web_alb.dns_name
}
