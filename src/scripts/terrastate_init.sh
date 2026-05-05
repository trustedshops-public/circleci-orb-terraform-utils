#!/bin/bash
set -euo pipefail

cd "${TERRASTATE_PARAM_PATH}"
terrastate --var-file "${TERRASTATE_PARAM_VAR_FILE}"
