resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.keypair.private_key_pem
  filename = "${path.module}/lamp_key.pem"
  file_permission = "0600"
}

resource "aws_key_pair" "keypair" {
  key_name   = "lamp_key"
  public_key = tls_private_key.keypair.public_key_openssh
}
