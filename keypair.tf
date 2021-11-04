resource "tls_private_key" "private_key" {
 algorithm = "RSA"
 rsa_bits = 4096
   }
   
resource "aws_key_pair" "pub_key" {
 key_name = "key"
 public_key = tls_private_key.private_key.public_key_openssh
}

resource "local_file" "private_key" {
    depends_on = [tls_private_key.private_key]
    content = tls_private_key.private_key.private_key_pem
    filename = "key.pem"
    file_permission = 0400
    }