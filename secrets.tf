resource "github_actions_secret" "AWS_KEY" {
  count           = length(var.repo)
  repository      = var.repo[count.index]["name"]
  secret_name     = "AWS_KEY"
  plaintext_value = var.AWS_KEY
}


resource "github_actions_secret" "AWS_ACCESS_KEY_ID" {
  count           = length(var.repo)
  repository      = var.repo[count.index]["name"]
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = var.AWS_ACCESS_KEY_ID
}

resource "github_actions_secret" "INFRACOST_API_KEY" {
  count           = length(var.repo)
  repository      = var.repo[count.index]["name"]
  secret_name     = "INFRACOST_API_KEY"
  plaintext_value = var.INFRACOST_API_KEY
}
