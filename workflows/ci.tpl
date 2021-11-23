---
# yamllint disable rule:line-length
name: Verify and Bump
on:
  schedule:
    - cron: "00 7 * * SUN"
  workflow_dispatch:
  push:
    branches:
      - ${ branch }
jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          ref: ${ branch }
          token: ${ token }
      - name: Config Terraform plugin cache
        run: |
          echo 'plugin_cache_dir="$HOME/.terraform.d/plugin-cache"' >~/.terraformrc
          mkdir --parents ~/.terraform.d/plugin-cache
      - name: Cache Terraform
        uses: actions/cache@v2
        with:
          path: |
            ~/.terraform.d/plugin-cache
          key: ${ key }
          restore-keys: |
            ${ restore }
      - name: Terraform Init
        uses: hashicorp/terraform-github-actions@master
        with:
          tf_actions_version: ${ terraform }
          tf_actions_subcommand: init
          tf_actions_working_dir: ${ targetdir }
      - name: Terraform Validate
        uses: hashicorp/terraform-github-actions@master
        with:
          tf_actions_version: ${ terraform }
          tf_actions_subcommand: validate
          tf_actions_working_dir: ${ targetdir }
      - name: Terraform Plan
        uses: hashicorp/terraform-github-actions@master
        with:
          tf_actions_version: ${ terraform }
          tf_actions_subcommand: plan
          tf_actions_working_dir: ${ targetdir }
        env:
          AWS_SECRET_ACCESS_KEY: ${ AWS_KEY }
          AWS_ACCESS_KEY_ID: ${ AWS_ACCESS_KEY_ID }
  security:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          ref: ${ branch }
          token: ${ token }
      - uses: actions/setup-python@v2
        with:
          python-version: 3.8
      - run: |
          pip3 install lastversion
          lastversion terraform-docs --assets -d --verbose
          mkdir $GITHUB_WORKSPACE/bin
          tar -xvf terraform-docs*.tar.gz --directory $GITHUB_WORKSPACE/bin
          chmod +x $GITHUB_WORKSPACE/bin/terraform-docs
          echo "$GITHUB_WORKSPACE/bin" >> $GITHUB_PATH
      - uses: pre-commit/action@v2.0.0
  version:
    name: versioning
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: Bump version and push tag
        uses: anothrNick/github-tag-action@master
        env:
          GITHUB_TOKEN: ${ token }
          DEFAULT_BUMP: patch
          WITH_V: "true"
    needs: [terraform, security]
