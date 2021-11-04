output "key_ssh"{
  value = tls_private_key.private_key.public_key_openssh
}

output "pubkey"{
value = tls_private_key.private_key.public_key_pem
}