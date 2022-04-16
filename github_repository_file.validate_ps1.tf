resource "github_repository_file" "validate_ps1" {
  count               = length(var.repo)
  repository          = var.repo[count.index]["name"]
  branch              = var.repo[count.index]["default_branch"]
  file                = "validate.ps1"
  content             = file("./validate.ps1")
  commit_message      = var.commit["message"]
  commit_author       = var.commit["author"]
  commit_email        = var.commit["email"]
  overwrite_on_create = true
}
