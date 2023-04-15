resource "aws_ecr_repository" "main" {
  name                 = "${var.project_name}-repository"
  image_tag_mutability = "IMMUTABLE"
  encryption_configuration {
    encryption_type = "KMS "
  }
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_configuration" "main" {
  repository = aws_ecr_repository.main.name

  rule {
    rule_action {
      type = "expire"
    }
    selection {
      tag_status = "untagged"
      count_type = "imageCountMoreThan"
      count_number = 10
    }
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.main.repository_url
}
