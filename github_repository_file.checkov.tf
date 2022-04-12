resource "github_repository_file" "checkov" {
  count      = length(var.repo)
  repository = var.repo[count.index]["name"]
  branch     = var.repo[count.index]["default_branch"]
  file       = ".checkov.yml"
  content = templatefile(".checkov.yml.tpl",
    {
      branch = var.repo[count.index]["default_branch"],
  })
  commit_message      = var.commit["message"]
  commit_author       = var.commit["author"]
  commit_email        = var.commit["email"]
  overwrite_on_create = true
}
