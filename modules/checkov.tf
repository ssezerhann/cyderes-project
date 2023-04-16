module "checkov" {
  source = "checkov/terraform"

  version = "1.0.8"

  terraform_version = "0.14"

  # Replace with the path to your Terraform code
  path = "."

  # Replace with the name of your Terraform backend
  backend_name = "cyderes"
}
