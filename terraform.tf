terraform {
  cloud {
    organization = "SphereVC"
    ## Required for Terraform Enterprise; Defaults to app.terraform.io for Terraform Cloud
    hostname = "app.terraform.io"

    workspaces {
    name    = "eks-minecraft-server"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}