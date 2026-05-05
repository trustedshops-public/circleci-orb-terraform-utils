#!/bin/bash
set -euo pipefail

GLOBAL_ARGS=()
SCAN_ARGS=()

if [[ -n "${TRIVY_PARAM_CONFIG_FILE}" ]]; then
  if [[ ! -f "${TRIVY_PARAM_CONFIG_FILE}" ]]; then
    echo "trivy config file not found: ${TRIVY_PARAM_CONFIG_FILE}" >&2
    exit 1
  fi
  # `--config` is a trivy *global* flag (selects trivy.yaml), distinct from
  # the `trivy config` subcommand we use to scan IaC. Place before the
  # subcommand to avoid ambiguity.
  GLOBAL_ARGS+=(--config "${TRIVY_PARAM_CONFIG_FILE}")
fi

if [[ -n "${TRIVY_PARAM_SEVERITY}" ]]; then
  SCAN_ARGS+=(--severity "${TRIVY_PARAM_SEVERITY}")
fi

# CircleCI serialises booleans as "0"/"1"; accept "true" too.
if [[ "${TRIVY_PARAM_EXIT_ON_FINDING}" == "1" || "${TRIVY_PARAM_EXIT_ON_FINDING}" == "true" ]]; then
  SCAN_ARGS+=(--exit-code 1)
fi

trivy "${GLOBAL_ARGS[@]}" config "${SCAN_ARGS[@]}" "${TRIVY_PARAM_PATH}"
