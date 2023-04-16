resource "aws_ecr_repository" "cyderes_ecr" {
  name                 = "cyderes-webserver"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(var.tags, {
    Name = "cyderes-ecr"
  })
}

data "aws_ecr_image" "cyderes_ecr_image" {
  repository_name = aws_ecr_repository.cyderes_ecr.name
  image_tag       = var.webserver_container_image
}

output "ecr_repository_url" {
  value = aws_ecr_repository.cyderes_ecr.repository_url
}
