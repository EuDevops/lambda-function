terraform {
  required_providers {
    aws = {
      version = ">= 3.70"
      source  = "hashicorp/aws"
    }
  }
  required_version = ">= 1.0"
}
