#!/bin/bash
set -euo pipefail

case "$(uname -m)" in
  x86_64) ARCH=amd64 ;;
  aarch64 | arm64) ARCH=arm64 ;;
  *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

BASE_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_PARAM_VERSION}"
BINARY_ZIP="terraform_${TERRAFORM_PARAM_VERSION}_linux_${ARCH}.zip"
CHECKSUM_FILE="terraform_${TERRAFORM_PARAM_VERSION}_SHA256SUMS"

WORK_DIR=$(mktemp -d)
trap 'rm -rf "${WORK_DIR}"' EXIT
cd "${WORK_DIR}"

curl --location --silent --show-error --fail --output "${BINARY_ZIP}" "${BASE_URL}/${BINARY_ZIP}"
curl --location --silent --show-error --fail --output "${CHECKSUM_FILE}" "${BASE_URL}/${CHECKSUM_FILE}"

sha256sum --check --ignore-missing "${CHECKSUM_FILE}"

unzip -o "${BINARY_ZIP}"
sudo mv terraform /usr/local/bin/terraform
sudo chmod +x /usr/local/bin/terraform

terraform version
