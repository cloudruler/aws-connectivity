terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.12.1"
    }
  }
  cloud {
      organization = "cloudruler"
      workspaces {
        name = "aws-connectivity"
      }
  }
}

provider "aws" {
}