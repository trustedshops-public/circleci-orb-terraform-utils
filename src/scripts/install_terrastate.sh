#!/bin/bash
set -euo pipefail

case "$(uname -m)" in
  x86_64) ARCH=amd64 ;;
  aarch64 | arm64) ARCH=arm64 ;;
  *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

URL="https://github.com/janritter/terrastate/releases/download/${TERRASTATE_PARAM_VERSION}/terrastate_linux_${ARCH}.tar.gz"

curl --location --silent --show-error --fail --output /tmp/terrastate.tar.gz "${URL}"
tar -xzf /tmp/terrastate.tar.gz -C /tmp
sudo mv /tmp/terrastate /usr/bin/terrastate
sudo chmod +x /usr/bin/terrastate
rm /tmp/terrastate.tar.gz

terrastate version
