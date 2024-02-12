terraform {
  cloud {
    organization = "SphereVC"

    workspaces {
      name = "Minecraft"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}