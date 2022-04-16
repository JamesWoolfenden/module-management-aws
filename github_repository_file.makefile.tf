resource "github_repository_file" "Makefile" {
  count               = length(var.repo)
  repository          = var.repo[count.index]["name"]
  branch              = var.repo[count.index]["default_branch"]
  file                = "example/examplea/Makefile"
  content             = file("./Makefile")
  commit_message      = var.commit["message"]
  commit_author       = var.commit["author"]
  commit_email        = var.commit["email"]
  overwrite_on_create = var.repo[count.index]["overwrite"]
}
