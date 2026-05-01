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

if [[ -f tfplan ]]; then
  # Saved plan present: apply exactly that plan. Var-files are baked into
  # the plan file already; passing -var-file here would be rejected by terraform.
  terraform apply -input=false -auto-approve tfplan
else
  APPLY_ARGS=()
  if [[ -n "${TERRAFORM_PARAM_VAR_FILE}" ]]; then
    APPLY_ARGS+=("-var-file=${TERRAFORM_PARAM_VAR_FILE}")
  fi
  terraform apply -input=false -auto-approve "${APPLY_ARGS[@]}"
fi
