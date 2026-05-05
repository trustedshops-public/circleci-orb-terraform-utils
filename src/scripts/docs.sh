#!/bin/bash
set -euo pipefail

DOCS_ARGS=()

if [[ -n "${TERRAFORM_DOCS_PARAM_CONFIG_FILE}" ]]; then
  if [[ ! -f "${TERRAFORM_DOCS_PARAM_CONFIG_FILE}" ]]; then
    echo "terraform-docs config file not found: ${TERRAFORM_DOCS_PARAM_CONFIG_FILE}" >&2
    exit 1
  fi
  DOCS_ARGS+=(--config "${TERRAFORM_DOCS_PARAM_CONFIG_FILE}")
fi

if [[ -n "${TERRAFORM_DOCS_PARAM_OUTPUT_FILE}" ]]; then
  DOCS_ARGS+=(--output-file "${TERRAFORM_DOCS_PARAM_OUTPUT_FILE}")
fi

# CircleCI serialises booleans as "0"/"1" when injecting into env vars;
# accept "true" too in case that ever changes.
if [[ "${TERRAFORM_DOCS_PARAM_CHECK}" == "1" || "${TERRAFORM_DOCS_PARAM_CHECK}" == "true" ]]; then
  DOCS_ARGS+=(--output-check)
fi

# Format may be a single word ("markdown") or two ("markdown table"); split on whitespace.
read -ra FORMAT_PARTS <<< "${TERRAFORM_DOCS_PARAM_FORMAT}"

terraform-docs "${FORMAT_PARTS[@]}" "${DOCS_ARGS[@]}" "${TERRAFORM_DOCS_PARAM_PATH}"
