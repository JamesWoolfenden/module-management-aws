terraform {
  required_providers {
    github = {
      version = "4.25.0-alpha"
      source  = "integrations/github"
    }
  }
  required_version = ">=0.14.8"
}
