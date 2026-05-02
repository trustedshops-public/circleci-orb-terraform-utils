#!/bin/bash
set -euo pipefail

cd "${TERRAFORM_PARAM_PATH}"

FMT_ARGS=()
# CircleCI serialises boolean parameters as "0"/"1" when injecting into
# environment variables; accept "true" too in case that ever changes.
if [[ "${TERRAFORM_PARAM_RECURSIVE}" == "1" || "${TERRAFORM_PARAM_RECURSIVE}" == "true" ]]; then
  FMT_ARGS+=(-recursive)
fi
if [[ "${TERRAFORM_PARAM_CHECK}" == "1" || "${TERRAFORM_PARAM_CHECK}" == "true" ]]; then
  FMT_ARGS+=(-check)
fi

terraform fmt "${FMT_ARGS[@]}"
