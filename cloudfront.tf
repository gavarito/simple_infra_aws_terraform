resource "aws_cloudfront_distribution" "task2_cf" {
   depends_on=[aws_s3_bucket.task2-anish-bucket]
   origin {
        domain_name = aws_s3_bucket.task2-anish-bucket.bucket_regional_domain_name
        origin_id = aws_s3_bucket.task2-anish-bucket.id
        
custom_origin_config {
            http_port = 80
            https_port = 80
            origin_protocol_policy = "match-viewer"
            origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"] 
        }
    }
       
    enabled = true
     is_ipv6_enabled = true
     
default_cache_behavior {
        allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = "${aws_s3_bucket.task2-anish-bucket.id}"
         forwarded_values {
            query_string = false
        
            cookies {
               forward = "none"
            }
        }
        
viewer_protocol_policy = "allow-all"
        min_ttl = 0
        default_ttl = 3600
        max_ttl = 86400
    }
    
# Restricts who is able to access this content
    
       restrictions {
          geo_restriction {
              restriction_type = "none"
        }
    }

viewer_certificate {
        cloudfront_default_certificate = true
    }
     
      connection {
             type = "ssh"
             user = "ec2-user"
             private_key = tls_private_key.private_key.private_key_pem
             host = aws_instance.Task-2.public_ip
     }
    
   provisioner "remote-exec" {
    
    inline = [
     
     "sudo su << EOF",
              "echo \"<img src='http://${self.domain_name}/${aws_s3_bucket_object.task2_object.key}'>\" >> /var/www/html/index.php",
              "EOF", 
    ]
   }
}