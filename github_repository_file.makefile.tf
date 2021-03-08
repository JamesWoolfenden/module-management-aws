resource "github_repository_file" "Makefile" {
  count               = length(var.repo)
  repository          = var.repo[count.index]["name"]
  branch              = var.repo[count.index]["default_branch"]
  file                = "example/examplea/Makefile"
  content             = file("./Makefile")
  commit_message      = "Managed by Terraform"
  commit_author       = "James Woolfenden"
  commit_email        = "james.woolfenden@gmail.com"
  overwrite_on_create = true
}
