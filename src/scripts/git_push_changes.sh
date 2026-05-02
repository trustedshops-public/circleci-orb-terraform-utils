#!/bin/bash
set -euo pipefail

# Refuse to push to a protected branch
for protected in ${GIT_PUSH_PARAM_PROTECTED_BRANCHES}; do
  if [[ "${GIT_PUSH_PARAM_BRANCH}" == "${protected}" ]]; then
    echo "Refusing to push to protected branch: ${GIT_PUSH_PARAM_BRANCH}" >&2
    echo "Set protected_branches to a list that excludes this branch to override." >&2
    exit 1
  fi
done

git config user.name "${GIT_PUSH_PARAM_USER_NAME}"
git config user.email "${GIT_PUSH_PARAM_USER_EMAIL}"

# shellcheck disable=SC2086
# Intentional word splitting on paths_to_add so users can pass "dir1 dir2 file.ext".
git add ${GIT_PUSH_PARAM_PATHS}

if git diff --cached --quiet; then
  echo "No staged changes; nothing to commit"
  exit 0
fi

git commit -m "${GIT_PUSH_PARAM_COMMIT_MESSAGE}"
git push origin "${GIT_PUSH_PARAM_BRANCH}"

if [[ "${GIT_PUSH_PARAM_FAIL_IF_CHANGES}" == "1" || "${GIT_PUSH_PARAM_FAIL_IF_CHANGES}" == "true" ]]; then
  echo "Pushed changes to ${GIT_PUSH_PARAM_BRANCH}; failing job to trigger CI re-run against new HEAD." >&2
  exit 1
fi

echo "Pushed changes to ${GIT_PUSH_PARAM_BRANCH}."
