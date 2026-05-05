#!/bin/bash
set -euo pipefail

case "$(uname -m)" in
  x86_64) ARCH="Linux-64bit" ;;
  aarch64 | arm64) ARCH="Linux-ARM64" ;;
  *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

# Trivy release tags are v-prefixed (e.g. v0.50.0) but asset filenames
# are not (e.g. trivy_0.50.0_Linux-64bit.tar.gz). Strip the v.
VERSION_NO_V="${TRIVY_PARAM_VERSION#v}"

URL="https://github.com/aquasecurity/trivy/releases/download/${TRIVY_PARAM_VERSION}/trivy_${VERSION_NO_V}_${ARCH}.tar.gz"

WORK_DIR=$(mktemp -d)
trap 'rm -rf "${WORK_DIR}"' EXIT
cd "${WORK_DIR}"

curl --location --silent --show-error --fail --output trivy.tar.gz "${URL}"
tar -xzf trivy.tar.gz
sudo mv trivy /usr/local/bin/trivy
sudo chmod +x /usr/local/bin/trivy

trivy --version
