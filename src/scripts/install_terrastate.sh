#!/bin/bash
set -euo pipefail

case "$(uname -m)" in
  x86_64) ARCH=amd64 ;;
  aarch64 | arm64) ARCH=arm64 ;;
  *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

URL="https://github.com/janritter/terrastate/releases/download/${TERRASTATE_PARAM_VERSION}/terrastate_linux_${ARCH}.tar.gz"

WORK_DIR=$(mktemp -d)
trap 'rm -rf "${WORK_DIR}"' EXIT
cd "${WORK_DIR}"

curl --location --silent --show-error --fail --output terrastate.tar.gz "${URL}"
tar -xzf terrastate.tar.gz
sudo mv terrastate /usr/bin/terrastate
sudo chmod +x /usr/bin/terrastate

terrastate version
