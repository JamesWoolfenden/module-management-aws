resource "github_repository_file" "validate_sh" {
  count               = length(var.repo)
  repository          = var.repo[count.index]["name"]
  branch              = var.repo[count.index]["default_branch"]
  file                = "validate.sh"
  content             = file("./validate.sh")
  commit_message      = "Managed by Terraform"
  commit_author       = "James Woolfenden"
  commit_email        = "james.woolfenden@gmail.com"
  overwrite_on_create = true
}
