---
# yamllint disable rule:line-length
name: Compare
on:
  schedule:
    - cron: "00 7 * * SAT"
  workflow_dispatch:

jobs:
  tfsec:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          ref: ${branch}
          token: ${token}
      - name: tfsec
        run: |
         pip3 install lastversion
         now=$(lastversion tfsec/tfsec)
         wget "https://github.com/tfsec/tfsec/releases/download/v${now}/tfsec-linux-amd64"
         chmod +x tfsec-linux-amd64
         ./tfsec-linux-amd64 ${ targetdir } -f json --out tfsec.json
        continue-on-error: true
      - name: store
        uses: actions/upload-artifact@v2
        with:
          name: tfsec
          path: tfsec.json
          if-no-files-found: error
  checkov:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          ref: ${ branch }
          token: ${ token }
      - name: install checkov
        run: |
          pip3 install checkov
      - name: run checkov
        run: checkov -d  ${ targetdir } -o json | tee checkov.json
        continue-on-error: true
      - name: store
        uses: actions/upload-artifact@v2
        with:
          name: checkov
          path: checkov.json
          if-no-files-found: error
  terrascan:
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
      - name: install terrascan
        run: |
          pip3 install lastversion
          now=$(lastversion accurics/terrascan)
          curl --location https://github.com/accurics/terrascan/releases/download/v${now}/terrascan_${now}_Linux_x86_64.tar.gz --output terrascan.tar.gz
          tar -xvf terrascan.tar.gz
      - name: run terrascan
        run: ./terrascan scan -d  ${ targetdir } -o json -x json >terrascan.json
        continue-on-error: true
      - name: store
        uses: actions/upload-artifact@v2
        with:
          name: terrascan
          path: terrascan.json
          if-no-files-found: error
  kics:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          ref: ${branch }
          token: ${ token }
      - name: run kics Scan
        uses: checkmarx/kics-action@v1.0
        with:
          path: ${ targetdir }
          output_path: "kics.json"
        continue-on-error: true
      - name: store
        uses: actions/upload-artifact@v2
        with:
          name: kics
          path: kics.json
          if-no-files-found: error

  upload:
    needs: [kics, terrascan, checkov, tfsec]
    runs-on: ubuntu-latest
    steps:
      - name: Get Time
        id: time
        uses: nanzm/get-time-action@v1.1
        with:
          timeZone: 8
          format: "YYYY-MM-DD-HH-mm-ss"
      - name: mkdir
        run: |
          mkdir  tos3
      - uses: actions/download-artifact@v2
        with:
          path: tos3
      - uses: jakejarvis/s3-sync-action@master
        with:
          args: --acl public-read --follow-symlinks --delete
        env:
          AWS_S3_BUCKET: compare-data-680235478471
          AWS_ACCESS_KEY_ID: ${ AWS_ACCESS_KEY_ID }
          AWS_SECRET_ACCESS_KEY: ${ AWS_KEY }
          AWS_REGION: "eu-west-2"
          SOURCE_DIR: tos3
          DEST_DIR: ${repository}/${steps}
