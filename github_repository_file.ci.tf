resource "github_repository_file" "ci" {
  count      = length(var.repo)
  repository = var.repo[count.index]["name"]
  branch     = var.repo[count.index]["default_branch"]
  file       = ".github/workflows/${var.repo[count.index]["default_branch"]}.yml"
  content = templatefile("./workflows/ci.tpl",
    {
      branch            = var.repo[count.index]["default_branch"],
      token             = "$${{ github.token }}",
      targetdir         = var.repo[count.index]["target_dir"],
      restore           = "$${{ runner.os }}-terraform-",
      terraform         = "1.0.1",
      AWS_ACCESS_KEY_ID = "$${{ secrets.AWS_ACCESS_KEY_ID }}",
      AWS_KEY           = "$${{ secrets.AWS_KEY }}",
      key               = "$${{ runner.os }}-terraform-$${{ hashFiles('**/.terraform.lock.hcl') }}",
      repository        = "$${{ github.repository }}",
      steps             = "$${{ steps.time.outputs.time }}"
  })
  commit_message      = var.commit["message"]
  commit_author       = var.commit["author"]
  commit_email        = var.commit["email"]
  overwrite_on_create = true
}
