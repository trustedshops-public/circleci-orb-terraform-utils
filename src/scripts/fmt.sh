#!/bin/bash
set -euo pipefail

cd "${TERRAFORM_PARAM_PATH}"

FMT_ARGS=()
if [[ "${TERRAFORM_PARAM_RECURSIVE}" == "true" ]]; then
  FMT_ARGS+=(-recursive)
fi
if [[ "${TERRAFORM_PARAM_CHECK}" == "true" ]]; then
  FMT_ARGS+=(-check)
fi

terraform fmt "${FMT_ARGS[@]}"
