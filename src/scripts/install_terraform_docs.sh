#!/bin/bash
set -euo pipefail

case "$(uname -m)" in
  x86_64) ARCH=amd64 ;;
  aarch64 | arm64) ARCH=arm64 ;;
  *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

URL="https://github.com/terraform-docs/terraform-docs/releases/download/${TERRAFORM_DOCS_PARAM_VERSION}/terraform-docs-${TERRAFORM_DOCS_PARAM_VERSION}-linux-${ARCH}.tar.gz"

curl --location --silent --show-error --fail --output /tmp/terraform-docs.tar.gz "${URL}"
tar -xzf /tmp/terraform-docs.tar.gz -C /tmp
sudo mv /tmp/terraform-docs /usr/local/bin/terraform-docs
sudo chmod +x /usr/local/bin/terraform-docs
rm /tmp/terraform-docs.tar.gz

terraform-docs --version
