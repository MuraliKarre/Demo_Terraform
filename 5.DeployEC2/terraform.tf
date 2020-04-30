terraform {
  backend "s3" {
    bucket = "wipro-cmp"
    key    = "Terraform/statefiles/EC2/terraform.tfstate"
    region = "us-east-2"
  }
}