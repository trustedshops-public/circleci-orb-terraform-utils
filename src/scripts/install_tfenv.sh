#!/bin/bash
set -euo pipefail

git clone https://github.com/tfutils/tfenv.git \
  --depth=1 \
  --branch "${TFENV_PARAM_VERSION}" \
  ~/.tfenv

# Single-quoted on purpose; $HOME and $PATH must expand at source time, not echo time
# shellcheck disable=SC2016
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> "${BASH_ENV}"
# shellcheck source=/dev/null
source "${BASH_ENV}"

tfenv --version

tfenv install latest
