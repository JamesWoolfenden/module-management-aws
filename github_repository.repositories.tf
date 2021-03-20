resource "github_repository" "repositories" {
  count                = length(var.repo)
  name                 = var.repo[count.index]["name"]
  allow_merge_commit   = true
  allow_rebase_merge   = true
  allow_squash_merge   = true
  description          = var.repo[count.index]["description"]
  has_downloads        = var.repo[count.index]["has_downloads"]
  has_issues           = var.repo[count.index]["has_issues"]
  has_projects         = var.repo[count.index]["has_projects"]
  has_wiki             = var.repo[count.index]["has_wiki"]
  visibility           = var.repo[count.index]["visibility"]
  vulnerability_alerts = var.repo[count.index]["vulnerability_alerts"]
  topics               = var.repo[count.index]["topics"]
}
