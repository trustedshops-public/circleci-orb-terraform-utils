#!/bin/bash
set -euo pipefail

if [[ -n "${TERRAFORM_PARAM_CLI_CONFIG_FILE}" ]]; then
  if [[ ! -f "${TERRAFORM_PARAM_CLI_CONFIG_FILE}" ]]; then
    echo "Terraform CLI config file not found: ${TERRAFORM_PARAM_CLI_CONFIG_FILE}" >&2
    exit 1
  fi
  export TF_CLI_CONFIG_FILE="${TERRAFORM_PARAM_CLI_CONFIG_FILE}"
fi

DESTROY_ARGS=()
if [[ -n "${TERRAFORM_PARAM_VAR_FILE}" ]]; then
  DESTROY_ARGS+=("-var-file=${TERRAFORM_PARAM_VAR_FILE}")
fi

cd "${TERRAFORM_PARAM_PATH}"
terraform destroy -input=false -auto-approve "${DESTROY_ARGS[@]}"
