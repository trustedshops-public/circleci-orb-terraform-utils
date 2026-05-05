#!/bin/bash
set -euo pipefail

INIT_ARGS=()
LINT_ARGS=()

if [[ -n "${TFLINT_PARAM_CONFIG_FILE}" ]]; then
  if [[ ! -f "${TFLINT_PARAM_CONFIG_FILE}" ]]; then
    echo "tflint config file not found: ${TFLINT_PARAM_CONFIG_FILE}" >&2
    exit 1
  fi
  INIT_ARGS+=(--config "${TFLINT_PARAM_CONFIG_FILE}")
  LINT_ARGS+=(--config "${TFLINT_PARAM_CONFIG_FILE}")
fi

# CircleCI serialises booleans as "0"/"1" when injecting into env vars;
# accept "true" too in case that ever changes.
if [[ "${TFLINT_PARAM_RECURSIVE}" == "1" || "${TFLINT_PARAM_RECURSIVE}" == "true" ]]; then
  LINT_ARGS+=(--recursive)
fi

cd "${TFLINT_PARAM_PATH}"

# Install any plugins declared in .tflint.hcl. No-op if none declared.
tflint --init "${INIT_ARGS[@]}"

tflint "${LINT_ARGS[@]}"
