
resource "aws_ecr_repository" "tessian" {
  name = "tessian" # Naming my repository
}

resource "null_resource" "docker_push" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com && docker tag my-django-app:latest ${aws_ecr_repository.tessian.repository_url}:latest && docker push ${aws_ecr_repository.tessian.repository_url}:latest"
  }
  depends_on = [
    aws_ecr_repository.tessian
  ]
  triggers = {
    always_run = "${timestamp()}"
  }
}



