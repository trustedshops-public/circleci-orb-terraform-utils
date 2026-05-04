# circleci-orb-terraform-utils

[![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/trustedshops-public/terraform-utils/blob/main/LICENSE)
[![pre-commit](https://img.shields.io/badge/%E2%9A%93%20%20pre--commit-enabled-success)](https://pre-commit.com/)
[![CircleCI Build Status](https://circleci.com/gh/trustedshops-public/circleci-orb-terraform-utils.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/trustedshops-public/circleci-orb-terraform-utils)
[![CircleCI Orb Version](https://badges.circleci.com/orbs/trustedshops-public/terraform-utils.svg)](https://circleci.com/orbs/registry/orb/trustedshops-public/terraform-utils)

A CircleCI orb covering the full Terraform CI/CD lifecycle: install the
toolchain (terraform, tfenv, terrastate, terraform-docs, tflint, trivy),
validate, lint, scan, plan, apply, destroy, generate docs, and auto-fix
formatting/docs back into the branch. ARM64 runners supported across every
installer.

## Contents

- [circleci-orb-terraform-utils](#circleci-orb-terraform-utils)
  - [Contents](#contents)
  - [Quick start](#quick-start)
  - [Jobs](#jobs)
  - [Commands](#commands)
  - [Multi-module via workflow matrix](#multi-module-via-workflow-matrix)
  - [Passing extra terraform flags](#passing-extra-terraform-flags)
  - [Authentication for auto-commit](#authentication-for-auto-commit)
    - [Branch protection](#branch-protection)
  - [Migrating from a previous major version](#migrating-from-a-previous-major-version)
  - [Contributing](#contributing)
    - [Commit Message Convention](#commit-message-convention)
    - [Publishing a new release](#publishing-a-new-release)
  - [Resources](#resources)

## Quick start

The simplest possible workflow — plan + apply on every push:

```yaml
version: 2.1

orbs:
  terraform-utils: trustedshops-public/terraform-utils@5.0.0

workflows:
  deploy:
    jobs:
      - terraform-utils/terraform_apply:
          terraform_version: "1.10.5"
          path: terraform
          var_file: vars/dev.tfvars
```

This installs terraform 1.10.5, runs `terraform init`, `terraform plan -out=tfplan`,
and `terraform apply tfplan` against the `terraform/` module.

## Jobs

Each job runs `checkout`, installs the toolchain, performs the action, and
persists any outputs to the workspace where appropriate.

| Job | Default behavior |
|---|---|
| `terraform_validate` | Init (no backend) + validate. Fast PR gate. |
| `terraform_init` | Init + persist `.terraform/` to the workspace. |
| `terraform_plan` | Init + plan + persist `tfplan` to the workspace. |
| `terraform_apply` | Init + plan + apply (single job; applies the plan it just produced). |
| `terraform_destroy` | Init + `terraform destroy -auto-approve`. |
| `terraform_fmt` | `terraform fmt -recursive -check`. With `auto_commit: true`, fixes in place and pushes. |
| `terraform_docs` | `terraform-docs --output-check`. With `auto_commit: true`, regenerates and pushes. |
| `terraform_lint` | `tflint --init` + `tflint`. |
| `terraform_security_scan` | `trivy config` with default `HIGH,CRITICAL` severity threshold. |

Each job exposes linear extension hooks: `pre_<verb>_steps` runs immediately
before that verb (`init`, `plan`, `apply`, `destroy`, `validate`, `fmt`, `docs`,
`lint`, `security_scan`), and `post_<verb>_steps` runs after the final verb of
the job. See [`src/examples/`](src/examples/) and the registry page for full
per-job usage and parameter reference.

## Commands

The orb exposes the following commands:

| Command | What it does |
|---|---|
| `install_tools` | Dispatches `install_terraform`, `install_tfenv`, `install_terrastate`, `install_terraform_docs`, `install_tflint`, `install_trivy` based on `*_version` parameters (default `none` skips). |
| `install_terraform`, `install_tfenv`, `install_terrastate`, `install_terraform_docs`, `install_tflint`, `install_trivy` | Single-tool installers. |
| `init`, `plan`, `apply`, `destroy`, `validate` | Native terraform wrappers. |
| `fmt`, `docs`, `lint`, `security_scan` | Native checker / formatter wrappers. |
| `terrastate_init` | Run `terrastate --var-file <file>` to generate the terrastate.tf state config. |
| `git_push_changes` | Configure git identity, stage, commit, push. Refuses to push to main/master. |
| `restore_provider_cache`, `save_provider_cache` | CircleCI cache primitives keyed on `<path>/.terraform.lock.hcl`. |

## Multi-module via workflow matrix

The orb does not have an internal `paths` parameter. Use CircleCI's native
[matrix](https://circleci.com/docs/configuration-reference/#matrix-requires-version-21) to fan out one job per module:

```yaml
workflows:
  pr_checks:
    jobs:
      - terraform-utils/terraform_plan:
          matrix:
            parameters:
              path: [ecr, ecs, pagerduty, statuscake]
          name: plan-<< matrix.path >>
          terraform_version: "1.10.5"
          var_file: ../vars/dev.tfvars
          filters:
            branches:
              ignore: main
```

## Passing extra terraform flags

The orb's commands don't expose every terraform flag as a parameter. For
one-off needs (`-target`, `-replace`, `-refresh-only`, etc.) use terraform's
built-in `TF_CLI_ARGS_<command>` env vars, set via `BASH_ENV` in a
`pre_<verb>_steps` hook.

```yaml
- terraform-utils/terraform_plan:
    terraform_version: "1.10.5"
    path: terraform
    pre_init_steps:
      - run:
          name: Plan only the SSM parameter
          command: echo 'export TF_CLI_ARGS_plan="-target=aws_ssm_parameter.smoke"' >> $BASH_ENV
```

Setting the env var in `pre_init_steps` puts it in scope for every later
terraform invocation in the same job — useful when a single job runs
init + plan + apply (e.g. `terraform_apply`).

## Authentication for auto-commit

`terraform_fmt` and `terraform_docs` with `auto_commit: true` need to push
back to the branch.

1. Create a GitHub PAT scoped to `contents:write` on the relevant repo.
2. Store it as `GITHUB_TOKEN` in a CircleCI context.
3. Set `rewrite_github_clone_url: true` on the job.

```yaml
- terraform-utils/terraform_fmt:
    auto_commit: true
    git_user_name: "ci-bot"
    git_user_email: "ci-bot@example.com"
    rewrite_github_clone_url: true
    context:
      - your-github-token-context
```

The orb runs `github-utils/rewrite_urls_with_token` early in the job, before
the fmt/docs/commit steps, so origin is already authenticated when
`git_push_changes` runs.

### Branch protection

The orb's `git_push_changes` refuses to push to `main`/`master` by default.
Override via the `protected_branches` parameter if you need to.

## Migrating from a previous major version

See [MIGRATION.md](MIGRATION.md) for the breaking changes between major
versions and how to handle each.

## Contributing

We welcome [issues](https://github.com/trustedshops-public/circleci-orb-terraform-utils/issues)
and [pull requests](https://github.com/trustedshops-public/circleci-orb-terraform-utils/pulls)
against this repository.

### Commit Message Convention

This repository follows [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).
Available types: `feat`, `fix`, `docs`, `style`, `chore`, `refactor`, `ci`,
`test`, `revert`, `perf`. Use the `!` suffix or a `BREAKING CHANGE:` footer
for breaking changes; `semantic-release` derives the next version from
these.

All commits must be signed off (`git commit -s ...`) per the repository's
[DCO](https://github.com/trustedshops-public/circleci-orb-terraform-utils/blob/main/.github/dco.yml)
configuration.

### Publishing a new release

Land changes on `main` with conventional-commit messages. CircleCI runs
`semantic-release`, which determines the next version from the commit
footers and publishes the orb to the registry.

## Resources

- [CircleCI Orb Registry Page](https://circleci.com/orbs/registry/orb/trustedshops-public/terraform-utils) — official registry; lists every version, executor, command, and job with full parameter reference.
- [CircleCI Orb Docs](https://circleci.com/docs/orb-intro/) — for using and creating orbs.
