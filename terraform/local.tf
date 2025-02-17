resource "local_file" "ansible_vars" {
  filename = "../ansible/vars.yml"
  file_permission = "0644"

  content = <<EOT
db_host: "${aws_instance.dbserver.private_ip}"
db_user: "ecomuser"
db_password: ""
db_name: "ecomdb"
web_server_ip: "${aws_eip.webserver_eip.public_ip}"
db_server_ip: "${aws_instance.dbserver.private_ip}"
EOT

}
