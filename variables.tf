variable "commit" {
  default = {
    message = "Managed by Terraform"
    author  = "James Woolfenden"
    email   = "james.woolfenden@gmail.com"
  }
}

variable "AWS_KEY" {
}

variable "AWS_ACCESS_KEY_ID" {
}


variable "repo" {
  type = list(any)
}
