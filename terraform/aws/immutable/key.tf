resource "tls_private_key" "keygen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "maintenance_key_pair" {
  key_name   = "maintenance-key"
  public_key = tls_private_key.keygen.public_key_openssh

  depends_on = [tls_private_key.keygen]
}

# 初回Key生成用
# openssl rsa -in maintenance-key.id_rsa -outform pem > maintenance-key.pem
#
#resource "local_file" "private_key_pem" {
#  filename = "./maintenance-key.id_rsa"
#  content  = tls_private_key.keygen.private_key_pem
#
#  depends_on = [tls_private_key.keygen]
#}
#
#resource "local_file" "public_key_openssh" {
#  filename = "./maintenance-key.id_rsa.pub"
#  content  = tls_private_key.keygen.public_key_openssh
#
#  depends_on = [tls_private_key.keygen]
#}