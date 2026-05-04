#!/bin/bash
set -euo pipefail

case "$(uname -m)" in
  x86_64) ARCH=amd64 ;;
  aarch64 | arm64) ARCH=arm64 ;;
  *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

URL="https://github.com/terraform-docs/terraform-docs/releases/download/${TERRAFORM_DOCS_PARAM_VERSION}/terraform-docs-${TERRAFORM_DOCS_PARAM_VERSION}-linux-${ARCH}.tar.gz"

WORK_DIR=$(mktemp -d)
trap 'rm -rf "${WORK_DIR}"' EXIT
cd "${WORK_DIR}"

curl --location --silent --show-error --fail --output terraform-docs.tar.gz "${URL}"
tar -xzf terraform-docs.tar.gz
sudo mv terraform-docs /usr/local/bin/terraform-docs
sudo chmod +x /usr/local/bin/terraform-docs

terraform-docs --version
