resource "github_branch_default" "default" {
  count      = length(var.repo)
  repository = var.repo[count.index]["name"]
  branch     = var.repo[count.index]["default_branch"]
}
