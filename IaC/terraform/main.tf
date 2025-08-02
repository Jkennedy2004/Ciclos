provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "b" {
  bucket = "my-devsecops-bucket-12345"
  acl    = "public-read" # ACL pública es una vulnerabilidad común
  tags = {
    Name        = "My DevSecOps Bucket"
    Environment = "Dev"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir todo el tráfico es una mala práctica
  }
}