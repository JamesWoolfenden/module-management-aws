---
# yamllint disable rule:line-length
name: Pull Request
on:
  pull_request:
  workflow_dispatch:

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          token: ${ token }
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
  infracost:
    runs-on: ubuntu-latest
    name: Show infracost diff
    steps:
      - name: Check out repository
        uses: actions/checkout@v2
      - name: Run infracost diff
        uses: infracost/infracost-gh-action@master # Use a specific version instead of master if locking is preferred
        env:
          INFRACOST_API_KEY: ${ INFRACOST_API_KEY }
          GITHUB_TOKEN: ${ token } # Do not change
          AWS_SECRET_ACCESS_KEY: ${ AWS_KEY }
          AWS_ACCESS_KEY_ID: ${ AWS_ACCESS_KEY_ID }
          # See the cloud credentials section for the options
        with:
          entrypoint: /scripts/ci/diff.sh # Do not change
          path: ${ targetdir }
          usage_file: ${ targetdir }/infracost-usage.yml
          #terraform_plan_flags: -var-file=my.tfvars
