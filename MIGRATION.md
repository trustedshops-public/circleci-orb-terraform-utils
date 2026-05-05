# Migration Guide

## v4 → v5

v5 is a breaking refactor. The orb is now self-contained for terraform
operations (no longer wraps `circleci/terraform`), gains native commands for
`init` / `plan` / `apply` / `destroy` / `validate`, adds `fmt`, `docs`,
`lint`, and `security_scan` jobs, and introduces an opt-in provider cache.

Below is every breaking change you may need to handle when bumping the
`@<version>` pin from `4.x` to `5.x`.

### `terraform_apply` job renamed to `apply`

v5 adopts a bare-verb naming convention for jobs (`apply`, `plan`, `init`,
etc.). The orb namespace `terraform-utils/` already conveys the domain, so
the per-job `terraform_` prefix was redundant. v4 only shipped one job
(`terraform_apply`), so this is the only rename you need to apply:

- `terraform-utils/terraform_apply` → `terraform-utils/apply`

The other v5 jobs (`init`, `plan`, `destroy`, `validate`, `fmt`, `docs`,
`lint`, `security_scan`) are new in v5; they ship with bare names from the
start.

### `provision` command removed

The `provision` command's orchestration is now inlined in the `apply` job.
Migrate by:

- **If you used `terraform-utils/provision` from your own jobs**: switch to
  invoking the orb's commands directly (`install_tools`, `terrastate_init`,
  `init`, `plan`, `apply`) or use the `apply` job.
- **If you used the `terraform_apply` job**: rename to `apply`. Parameters
  and behavior are otherwise preserved (subject to the other notes below).

### `terraform_apply_with_circleci_ip_range` job removed

CircleCI parses `circleci_ip_ranges: true` at config-load time, so it can't
be toggled by a runtime parameter. Rather than ship a near-duplicate job,
v5 expects consumers who need IP-range whitelisting to define their own job:

```yaml
jobs:
  apply-via-static-ips:
    executor: terraform-utils/default
    circleci_ip_ranges: true
    steps:
      - checkout
      - terraform-utils/install_tools:
          terraform_version: "1.10.5"
      - terraform-utils/init:
          path: terraform
      - terraform-utils/plan:
          path: terraform
          var_file: vars/dev.tfvars
      - terraform-utils/apply:
          path: terraform
          var_file: vars/dev.tfvars
```

### `var_file` default changed from `"vars.tfvars"` to `""`

When `var_file` is empty (the new default), the `-var-file` flag is omitted
entirely from the underlying terraform invocations. This means:

- **Modules without a tfvars file** now work without explicitly setting
  `var_file: ""`.
- **Modules that relied on the implicit `vars.tfvars` default** must set
  `var_file: vars.tfvars` explicitly on every job invocation.

### `circleci/terraform` orb dependency dropped

v4 transitively imported `circleci/terraform@3.x`, so consumers could
reference `terraform/init`, `terraform/plan`, etc. from their own jobs without
an explicit import. v5 doesn't import it.

If you used `terraform/*` directly anywhere outside the orb's scope, add the
import yourself:

```yaml
orbs:
  terraform-utils: trustedshops-public/terraform-utils@5.0.0
  terraform: circleci/terraform@3.3.0   # only if you used it directly
```

### Default executor changed from `cimg/python:3.11.2` to `cimg/base:2026.04`

The orb's commands don't require Python. `cimg/base` is leaner (faster
container pull, less surface area) and ships a newer git that some
consumer-side commands depend on. Migrate by:

- **If you didn't override the executor**: nothing to do.
- **If you depended on Python being preinstalled in the orb's executor**:
  install Python yourself in `pre_init_steps`, override the `tag` parameter
  to a `cimg/python:*` variant, or supply your own executor.

```yaml
- terraform-utils/apply:
    tag: "3.11.2"   # if you really need cimg/python:3.11.2 back
```

### Hook parameter `post_init_steps` renamed to `pre_plan_steps`

In v4, the slot between `terraform init` and `terraform plan` (in the
`apply` and `plan` jobs) was named `post_init_steps`. v5 renames it to
`pre_plan_steps` so all hook names follow the same "runs immediately before
the named verb" convention. Same semantic, new name. Find-and-replace in
your `.circleci/config.yml`.

### Apply uses a saved tfplan internally

In v4, the apply job ran `init` → `plan` → `apply`, where each step's own
internal plan could differ from the previous. In v5, the job runs
`init` → `plan -out=tfplan` → `apply tfplan` — the applied plan is exactly
the plan that was previewed within the same job.

No action required to migrate; this is a behavior improvement that may
remove drift surprises in long-running pipelines.

**Caveat:** the saved `tfplan` snapshots the state at plan time. If anything
else mutates the state between plan and apply (e.g. a manual
`terraform apply` from a workstation, or a parallel pipeline run on the
same backend), the stored plan becomes stale and apply will refuse to
use it. In practice this means the pipeline should be the single source
of truth for applies during the plan-to-apply window.

### terrastate is no longer used inside `terrastate apply` flows

v5 keeps terrastate's role intentionally minimal: it generates the
`terrastate.tf` file (the state-backend configuration) and that's it.
The orb does not call `terrastate plan` / `terrastate apply` /
`terrastate destroy` even though terrastate supports those commands.

If you previously relied on the orb running terrastate's apply/destroy
modes, replace those with the equivalent native `terraform` invocations
from the orb (`apply`, `destroy`).
