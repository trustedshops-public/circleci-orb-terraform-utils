terraform {
  required_version = ">= 1.10"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.3.1"
    }
  }
}

provider "null" {
  # Configuration options
}

resource "null_resource" "this" {
  # Does nothing
}
