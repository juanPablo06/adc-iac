terraform {
  backend "s3" {
    bucket         = "terraform-backend-ue1"
    key            = "adc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}
