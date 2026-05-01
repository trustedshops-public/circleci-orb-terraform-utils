#!/bin/bash
set -euo pipefail

cd "${TFENV_PARAM_PATH}"
tfenv install
tfenv use
