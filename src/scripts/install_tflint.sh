#!/bin/bash
set -euo pipefail

case "$(uname -m)" in
  x86_64) ARCH=amd64 ;;
  aarch64 | arm64) ARCH=arm64 ;;
  *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

URL="https://github.com/terraform-linters/tflint/releases/download/${TFLINT_PARAM_VERSION}/tflint_linux_${ARCH}.zip"

WORK_DIR=$(mktemp -d)
trap 'rm -rf "${WORK_DIR}"' EXIT
cd "${WORK_DIR}"

curl --location --silent --show-error --fail --output tflint.zip "${URL}"
unzip -o tflint.zip
sudo mv tflint /usr/local/bin/tflint
sudo chmod +x /usr/local/bin/tflint

tflint --version
