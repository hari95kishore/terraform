terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.23.0"
    }
  }
  backend "s3" {
    bucket = "elopage-tfstate"
    key    = "elopage/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.region
}