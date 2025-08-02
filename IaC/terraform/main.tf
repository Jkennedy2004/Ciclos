provider "aws" {
  region = "us-east-1"
}

# La configuración del S3 Bucket se ha actualizado con buenas prácticas de seguridad.
# Ahora el bucket es privado, tiene encriptación, y bloquea el acceso público.
# También se ha habilitado el control de versiones para proteger contra eliminaciones accidentales.
resource "aws_s3_bucket" "b" {
  bucket = "my-devsecops-bucket-12345"
  # Se cambió la ACL a "private" para evitar el acceso público
  acl = "private" 
  tags = {
    Name        = "My DevSecOps Bucket"
    Environment = "Dev"
  }
}

# Se agrega un bloque de acceso público para S3.
# Se habilita la encriptación por defecto para proteger los datos en reposo.
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.b.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.b.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.b.id
  versioning_configuration {
    status = "Enabled"
  }
}

# El recurso del Security Group "aws_security_group.web_sg" fue eliminado
# para resolver el error de Checkov "CKV2_AWS_5". Este recurso no estaba
# siendo utilizado por ningún otro recurso, lo que es considerado una mala práctica.
# Si necesitas un grupo de seguridad para un nuevo recurso, puedes agregarlo aquí.