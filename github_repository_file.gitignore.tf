resource "github_repository_file" "gitignore" {
  count               = length(var.repo)
  repository          = var.repo[count.index]["name"]
  branch              = var.repo[count.index]["default_branch"]
  file                = ".gitignore"
  content             = file("./.gitignore")
  commit_message      = "Managed by Terraform"
  commit_author       = "James Woolfenden"
  commit_email        = "james.woolfenden@gmail.com"
  overwrite_on_create = true
}
