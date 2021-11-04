resource "aws_s3_bucket" "task2-anish-bucket" {
  bucket = "task2-anish-bucket"
  acl = "public-read"
 
  versioning {
    enabled = true
  }
  
  tags = {
    Name = "task2-anish-bucket"
  }
}

resource "aws_s3_bucket_object" "task2_object" {
  bucket = aws_s3_bucket.task2-anish-bucket.id
  key    = "image.jpg"
  source = "C:/Users/Anish garg/Desktop/practical.jpg"   
  acl = "public-read"
  
  force_destroy = true
  }
 
 locals{
             s3_origin_id = "S3-${aws_s3_bucket.task2-anish-bucket.bucket}"
}