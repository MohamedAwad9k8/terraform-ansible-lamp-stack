output "webserver_public_ip" {
  description = "The public IP of the web server"
  value       = aws_eip.webserver_eip.public_ip
}

output "webserver_private_ip" {
  description = "The private IP of the web server"
  value       = aws_instance.webserver.private_ip
}

output "dbserver_private_ip" {
  description = "The private IP of the database server"
  value       = aws_instance.dbserver.private_ip
}
