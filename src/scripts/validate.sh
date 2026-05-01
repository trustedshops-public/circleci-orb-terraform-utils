#!/bin/bash
set -euo pipefail

if [[ -n "${TERRAFORM_PARAM_CLI_CONFIG_FILE}" ]]; then
  if [[ ! -f "${TERRAFORM_PARAM_CLI_CONFIG_FILE}" ]]; then
    echo "Terraform CLI config file not found: ${TERRAFORM_PARAM_CLI_CONFIG_FILE}" >&2
    exit 1
  fi
  export TF_CLI_CONFIG_FILE="${TERRAFORM_PARAM_CLI_CONFIG_FILE}"
fi

cd "${TERRAFORM_PARAM_PATH}"
terraform init -input=false -backend=false
terraform validate
