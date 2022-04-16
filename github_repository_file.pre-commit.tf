resource "github_repository_file" "pre-commit" {
  count               = length(var.repo)
  repository          = var.repo[count.index]["name"]
  branch              = var.repo[count.index]["default_branch"]
  file                = ".pre-commit-config.yaml"
  content             = file(".pre-commit-config.yaml")
  commit_message      = var.commit["message"]
  commit_author       = var.commit["author"]
  commit_email        = var.commit["email"]
  overwrite_on_create = true
}
