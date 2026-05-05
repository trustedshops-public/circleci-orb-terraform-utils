#!/bin/bash
set -euo pipefail

# Resolve the target branch. Empty GIT_PUSH_PARAM_BRANCH means "use the
# current CircleCI branch". CCI parameter defaults can't reference
# ${CIRCLE_BRANCH} because YAML does not bash-expand value templates.
TARGET_BRANCH="${GIT_PUSH_PARAM_BRANCH:-${CIRCLE_BRANCH:-}}"

if [[ -z "${TARGET_BRANCH}" ]]; then
  echo "No target branch resolved: branch param is empty and CIRCLE_BRANCH is unset." >&2
  exit 1
fi

# Refuse to push to a protected branch
for protected in ${GIT_PUSH_PARAM_PROTECTED_BRANCHES}; do
  if [[ "${TARGET_BRANCH}" == "${protected}" ]]; then
    echo "Refusing to push to protected branch: ${TARGET_BRANCH}" >&2
    echo "Set protected_branches to a list that excludes this branch to override." >&2
    exit 1
  fi
done

# shellcheck disable=SC2086
# Intentional word splitting on paths_to_add so users can pass "dir1 dir2 file.ext".
git add ${GIT_PUSH_PARAM_PATHS}

if git diff --cached --quiet; then
  echo "No staged changes; nothing to commit"
  exit 0
fi

# Scope the bot identity to this commit only. Avoids leaking ci-bot
# author/committer values into the local .git/config, which would
# otherwise apply to any later steps that share the working tree
# (e.g. another checkout + commit in the same job).
git -c user.name="${GIT_PUSH_PARAM_USER_NAME}" \
    -c user.email="${GIT_PUSH_PARAM_USER_EMAIL}" \
    commit -m "${GIT_PUSH_PARAM_COMMIT_MESSAGE}"
git push origin "${TARGET_BRANCH}"

if [[ "${GIT_PUSH_PARAM_FAIL_IF_CHANGES}" == "1" || "${GIT_PUSH_PARAM_FAIL_IF_CHANGES}" == "true" ]]; then
  echo "Pushed changes to ${TARGET_BRANCH}; failing job to trigger CI re-run against new HEAD." >&2
  exit 1
fi

echo "Pushed changes to ${TARGET_BRANCH}."
