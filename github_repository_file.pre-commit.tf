resource "github_repository_file" "pre-commit" {
  count               = length(var.repo)
  repository          = var.repo[count.index]["name"]
  branch              = var.repo[count.index]["default_branch"]
  file                = ".pre-commit-config.yaml"
  content             = file(".pre-commit-config.yaml")
  commit_message      = "Managed by Terraform"
  commit_author       = "James Woolfenden"
  commit_email        = "james.woolfenden@gmail.com"
  overwrite_on_create = true
}
