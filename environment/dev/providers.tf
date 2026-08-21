terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "tr-archicture-state-lock-763103708432-us-east-1-an"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "archicture-tf-state-lock"
  }

}



provider "aws" {
  region = var.aws_region
}