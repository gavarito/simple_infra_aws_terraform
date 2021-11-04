resource "aws_instance"  "instance" {
  ami   = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name   = aws_key_pair.pub_key.key_name
  security_groups = ["sg"]
  availability_zone = "ap-south-1b"
  tags = {
        Name = "My_instance"
   }
}

resource "aws_efs_file_system" "EFS-task"{
 creation_token="efs"
 
tags = {
Name= "EFS-task"
 }
}

resource "aws_efs_mount_target" "mount" {
file_system_id = aws_efs_file_system.EFS-task.id
subnet_id = "subnet-d0006b9c"
security_groups= [aws_security_group.security_group.id]
}

resource "null_resource" "mounting" {
depends_on = [ aws_efs_mount_target.mount, ]

connection  { 
             type = "ssh"
             user = "ec2-user"
             private_key = tls_private_key.private_key.private_key_pem
             host = aws_instance.Task-2.public_ip
      }
provisioner "remote-exec" {
    inline = [ 
                   "sudo yum install httpd php git -y",
                   "sudo systemctl restart httpd",
                   "sudo systemctl enable httpd",
                   "sudo mkfs.ext4  /dev/xvdh",
                   " sudo mount /dev/xvdh  /var/www/html",
                   " sudo rm -rf /var/www/html/*",
                   "sudo git clone https://github.com/anish5207/hybrid-task1.git  /var/www/html",
                   "sudo yum install nfs-utils -y"
                  ]
          }
   }