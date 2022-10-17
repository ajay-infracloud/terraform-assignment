terraform {
  required_version = ">= 0.13.0"
  backend "s3" {
    bucket = "infracloud-test-state"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}
