## [5.1.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/5.0.0...5.1.0) (2026-05-08)


### Features

* **jobs:** make executor configurable via parameter ([a5fc1de](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/a5fc1deaa9d4f8eb2260b014e079f3aeace1a113))

## [5.0.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/4.0.0...5.0.0) (2026-05-05)


### ⚠ BREAKING CHANGES

* drop terraform_ prefix from job names
* **deps:** consumers of this orb who relied on circleci/terraform
being transitively imported and accessible as terraform/* must import
it directly in their own .circleci/config.yml.

Signed-off-by: Timo Krause <timo.krause@trustedshops.com>
* var_file default changes from "vars.tfvars" to ""
(empty string). When empty, the -var-file flag is omitted entirely.
Modules without a tfvars file now work without overriding var_file;
modules relying on the implicit "vars.tfvars" default must set the
parameter explicitly.
* the provision command is removed. Its orchestration
moves into the terraform_apply job. Consumers calling
terraform-utils/provision directly must switch to the terraform_apply
job or compose the orb's commands themselves.
* post_init_steps parameter renamed to pre_plan_steps
on terraform_apply and terraform_plan. The semantic is unchanged
(still runs between init and plan) but the name is now consistent
with the rest of the linear hook scheme.

Signed-off-by: Timo Krause <timo.krause@trustedshops.com>
* **jobs:** terraform_apply_with_circleci_ip_range job removed.
Migration: define a custom job in your CI config that wraps the orb's
commands and adds circleci_ip_ranges: true at the job level. Full
example will be in CHANGELOG/README at the end of the v5 refactor.

Signed-off-by: Timo Krause <timo.krause@trustedshops.com>
* **executor:** default executor image changed from cimg/python:3.11.2
to cimg/base:stable. Consumers relying on Python being present in the
default executor must either install Python in pre_init_steps, override
the executor, or pin to v4.x.

Signed-off-by: Timo Krause <timo.krause@trustedshops.com>

### Features

* **cache:** add opt-in terraform provider caching ([200be0b](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/200be0be7b6a9033bbb182baa0f8ce2e222418d2))
* **destroy:** add native destroy command and terraform_destroy job ([858226d](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/858226db750ff4c0b31826e425c43574f365fdcd))
* **docs:** add terraform_docs job with terraform-docs install + auto-commit ([c70c9c9](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/c70c9c974e85035366025aa5de2e79acae160223))
* drop terraform_ prefix from job names ([0e09966](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/0e09966ad1bf531220a0e16d69d3662f0e37bc85))
* **fmt:** add terraform_fmt job and fmt command with auto-commit ([dec19dc](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/dec19dcdec21d44e06f41705663c3763a637aafb))
* **git:** add git_push_changes shared command ([121c542](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/121c542241bb2fce08d71131809679ec50b70e41))
* **install:** add native install_terraform command with arch detection ([63c8b39](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/63c8b39bf8d6544bf788f4edd24271f3501da1e0))
* **lint:** add terraform_lint job with tflint install ([1b0d178](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/1b0d17848b72bb039bdf23060d4a7773b2de10ad))
* replace terraform wrap with native init/plan/apply commands and split jobs ([97fe158](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/97fe1586d77c36ee0e5e0c23510635a3bf67b4ce))
* **security:** add terraform_security_scan job with trivy ([e4d5a38](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/e4d5a386d427220a5e944cc5c7ecd6821e6c4b1d))
* **validate:** add terraform_validate job and validate command ([683b656](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/683b65633e60ecae13538abc9ffcf47657d678be))


### Bug Fixes

* **git_push_changes:** resolve branch from CIRCLE_BRANCH at runtime ([a2181a6](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/a2181a698893603ff69df2aa82f20eeb3402a15d))
* **git_push:** scope bot git identity to the commit only ([8feda2b](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/8feda2bdbfab0101074ab631b9bc4bc22f183380))
* **scripts:** accept CircleCI's "1" serialisation for boolean params ([10a60ee](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/10a60ee0adabb8add8e18c210f4ee30a9267fa3e))


### Miscellaneous Chores

* **deps:** drop circleci/terraform orb dependency ([9f9ec51](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/9f9ec51225de8ebd907302507dfe8026cb7c7ad5))


### Code Refactoring

* **executor:** use cimg/base:stable instead of cimg/python ([125fc90](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/125fc9073d528c5dc28c249fc3c43ace9ce68e2e))
* **jobs:** drop terraform_apply_with_circleci_ip_range ([65c2a76](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/65c2a76d8245e076b937717b8ac8fe6847f58e97))

## [4.0.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/3.1.0...4.0.0) (2026-03-24)


### ⚠ BREAKING CHANGES

* terrastate releases are now distributed as tar.gz archives instead of raw binaries. The install command now downloads and extracts the archive.

Signed-off-by: Timo Krause <timo.krause@trustedshops.com>

### Features

* update terrastate to 2.2.1 with tar.gz release format ([8bf44b5](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/8bf44b53070a7cd946231a42d78c281f43bf5833))

## [3.1.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/3.0.0...3.1.0) (2024-10-21)


### Features

* update semantic-release orb ([704a255](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/704a255939c2ca21ce7d0c25f4613e1274de9771))
* update terraform orb ([bbe443f](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/bbe443f3eea9d1f57148412a410219c80f2a3488))


### Bug Fixes

* broken terrastate download ([b4b630d](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/b4b630d9d07d07189ef8a12f69a3c00d39e3c892))
* broken terrastate download ([d3b70b5](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/d3b70b57b63d369e86b0cc8802b05b606f7df432))
* default pointing to non-existent version ([e84640e](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/e84640eade67418dedb2ef6603b7fbcf64be880d))

## [3.0.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/2.0.0...3.0.0) (2024-10-21)


### ⚠ BREAKING CHANGES

* Migrate to orb tools v12

### Features

* update semantic-release orb ([704a255](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/704a255939c2ca21ce7d0c25f4613e1274de9771))
* update terraform orb ([bbe443f](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/bbe443f3eea9d1f57148412a410219c80f2a3488))


### Bug Fixes

* Add github utils for url rewrite ([2a02196](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/2a02196029635b9b879aac044f61e414c5addef1))
* Add token as username to github access token ([cbb72c6](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/cbb72c6af7bd8811cbfd97a31fb068e321daa603))
* broken terrastate download ([d3b70b5](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/d3b70b57b63d369e86b0cc8802b05b606f7df432))
* default pointing to non-existent version ([e84640e](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/e84640eade67418dedb2ef6603b7fbcf64be880d))


### Code Refactoring

* Migrate to orb tools v12 ([18c7c9f](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/18c7c9f0a36e96c7499f88e9eec010af1762fef5))

## [3.0.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/2.0.0...3.0.0) (2024-10-16)


### ⚠ BREAKING CHANGES

* Migrate to orb tools v12

### Features

* update semantic-release orb ([704a255](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/704a255939c2ca21ce7d0c25f4613e1274de9771))
* update terraform orb ([bbe443f](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/bbe443f3eea9d1f57148412a410219c80f2a3488))


### Bug Fixes

* Add github utils for url rewrite ([2a02196](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/2a02196029635b9b879aac044f61e414c5addef1))
* Add token as username to github access token ([cbb72c6](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/cbb72c6af7bd8811cbfd97a31fb068e321daa603))
* default pointing to non-existent version ([e84640e](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/e84640eade67418dedb2ef6603b7fbcf64be880d))


### Code Refactoring

* Migrate to orb tools v12 ([18c7c9f](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/18c7c9f0a36e96c7499f88e9eec010af1762fef5))

## [3.0.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/2.0.0...3.0.0) (2024-09-23)


### ⚠ BREAKING CHANGES

* Migrate to orb tools v12

### Bug Fixes

* Add github utils for url rewrite ([2a02196](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/2a02196029635b9b879aac044f61e414c5addef1))
* Add token as username to github access token ([cbb72c6](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/cbb72c6af7bd8811cbfd97a31fb068e321daa603))


### Code Refactoring

* Migrate to orb tools v12 ([18c7c9f](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/18c7c9f0a36e96c7499f88e9eec010af1762fef5))

## [3.0.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/2.0.0...3.0.0) (2024-02-15)


### ⚠ BREAKING CHANGES

* Migrate to orb tools v12

### Bug Fixes

* Add github utils for url rewrite ([2a02196](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/2a02196029635b9b879aac044f61e414c5addef1))
* Add token as username to github access token ([cbb72c6](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/cbb72c6af7bd8811cbfd97a31fb068e321daa603))


### Code Refactoring

* Migrate to orb tools v12 ([18c7c9f](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/18c7c9f0a36e96c7499f88e9eec010af1762fef5))

## [3.0.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/2.0.0...3.0.0) (2023-07-20)


### ⚠ BREAKING CHANGES

* Migrate to orb tools v12

### Bug Fixes

* Add github utils for url rewrite ([2a02196](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/2a02196029635b9b879aac044f61e414c5addef1))
* Add token as username to github access token ([cbb72c6](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/cbb72c6af7bd8811cbfd97a31fb068e321daa603))


### Code Refactoring

* Migrate to orb tools v12 ([18c7c9f](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/18c7c9f0a36e96c7499f88e9eec010af1762fef5))

## [3.0.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/2.0.0...3.0.0) (2023-06-29)


### ⚠ BREAKING CHANGES

* Migrate to orb tools v12

### Bug Fixes

* Add github utils for url rewrite ([2a02196](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/2a02196029635b9b879aac044f61e414c5addef1))
* Add token as username to github access token ([cbb72c6](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/cbb72c6af7bd8811cbfd97a31fb068e321daa603))


### Code Refactoring

* Migrate to orb tools v12 ([18c7c9f](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/18c7c9f0a36e96c7499f88e9eec010af1762fef5))

## [3.0.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/2.0.0...3.0.0) (2023-06-29)


### ⚠ BREAKING CHANGES

* Migrate to orb tools v12

### Bug Fixes

* Add token as username to github access token ([cbb72c6](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/cbb72c6af7bd8811cbfd97a31fb068e321daa603))


### Code Refactoring

* Migrate to orb tools v12 ([18c7c9f](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/18c7c9f0a36e96c7499f88e9eec010af1762fef5))

## [3.0.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/2.0.0...3.0.0) (2023-06-19)


### ⚠ BREAKING CHANGES

* Migrate to orb tools v12

### Code Refactoring

* Migrate to orb tools v12 ([18c7c9f](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/18c7c9f0a36e96c7499f88e9eec010af1762fef5))

## [3.0.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/2.0.0...3.0.0) (2023-06-07)


### ⚠ BREAKING CHANGES

* Migrate to orb tools v12

### Code Refactoring

* Migrate to orb tools v12 ([18c7c9f](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/18c7c9f0a36e96c7499f88e9eec010af1762fef5))

## [3.0.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/2.0.0...3.0.0) (2023-05-31)


### ⚠ BREAKING CHANGES

* Migrate to orb tools v12

### Code Refactoring

* Migrate to orb tools v12 ([18c7c9f](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/18c7c9f0a36e96c7499f88e9eec010af1762fef5))

## [3.0.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/2.0.0...3.0.0) (2023-05-28)


### ⚠ BREAKING CHANGES

* Migrate to orb tools v12

### Code Refactoring

* Migrate to orb tools v12 ([18c7c9f](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/18c7c9f0a36e96c7499f88e9eec010af1762fef5))

## [3.0.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/2.0.0...3.0.0) (2023-05-26)


### ⚠ BREAKING CHANGES

* Migrate to orb tools v12

### Code Refactoring

* Migrate to orb tools v12 ([18c7c9f](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/18c7c9f0a36e96c7499f88e9eec010af1762fef5))

## [2.0.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/1.8.0...2.0.0) (2023-02-28)


### ⚠ BREAKING CHANGES

* **deps:** Major update of tfenv can break things

### Bug Fixes

* **deps:** update dependency tfutils/tfenv to v2.2.3 ([#12](https://github.com/trustedshops-public/circleci-orb-terraform-utils/issues/12)) ([44d5527](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/44d5527e7780b6743354fc1ef23c5ea392e5b905))
* **deps:** update dependency tfutils/tfenv to v3 ([#13](https://github.com/trustedshops-public/circleci-orb-terraform-utils/issues/13)) ([ad34f25](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/ad34f256f730947af2009c1d82ab42472be7828d))

## [1.8.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/1.7.1...1.8.0) (2023-02-28)


### Features

* Update python cimg ([a53f4b9](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/a53f4b952175078c3559bfdec98fb6d0b2f33bf9))

## [1.7.1](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/1.7.0...1.7.1) (2023-02-22)


### Bug Fixes

* updated to latest terrastate version ([2dab7da](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/2dab7da7297370e9cdb410642fa78b05f4703509))

# [1.7.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/1.6.0...1.7.0) (2022-09-20)


### Features

* Add possibility to execute custom steps pre- and post-init ([#3](https://github.com/trustedshops-public/circleci-orb-terraform-utils/issues/3)) ([9609cec](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/9609cecae2664a17e191a67f1db2d64026fe2da8))

# [1.6.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/1.5.0...1.6.0) (2022-01-12)


### Features

* **#1:** Add circleci ip range support ([#2](https://github.com/trustedshops-public/circleci-orb-terraform-utils/issues/2)) ([14dce9c](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/14dce9c17392c25a1b007fdf4b1735cd8928f141)), closes [#1](https://github.com/trustedshops-public/circleci-orb-terraform-utils/issues/1) [#1](https://github.com/trustedshops-public/circleci-orb-terraform-utils/issues/1) [#1](https://github.com/trustedshops-public/circleci-orb-terraform-utils/issues/1)

# [1.5.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/1.4.0...1.5.0) (2021-11-17)


### Features

* Add example jobs for tfenv and plain terraform versions ([88efa1f](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/88efa1fe25da2f4c5cda05812782d2438bac05ab))

# [1.4.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/1.3.0...1.4.0) (2021-11-16)


### Features

* Change default executor to python ([1fda497](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/1fda4974be4e0387ed8352676a9bb40c64f149c2))

# [1.3.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/1.2.0...1.3.0) (2021-11-16)


### Features

* Add attach workspace and checkout parameter to terraform apply job ([ee578c5](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/ee578c53f3e77c29f2f310e6ed042bcd2bf166e4))

# [1.2.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/1.1.1...1.2.0) (2021-11-16)


### Features

* Add github token module url rewrite ([bf4ff22](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/bf4ff2297748dd6ec8d22f09ad66aae4ad016327))

## [1.1.1](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/1.1.0...1.1.1) (2021-11-16)


### Bug Fixes

* Run tfenv install independent from terraform commands ([36abbd6](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/36abbd6b0b182309cf3532e5762b5366f638745a))

# [1.1.0](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/1.0.2...1.1.0) (2021-11-16)


### Features

* Install latest version with tfenv automatically ([09d0d36](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/09d0d369aa89cc0ce0abdaffeb9aaf9f41161a72))

## [1.0.2](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/1.0.1...1.0.2) (2021-11-16)


### Bug Fixes

* Source tfenv before checking version ([bc05c21](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/bc05c21e659bd434e4cfe7428cfa1a05e4fcddc1))

## [1.0.1](https://github.com/trustedshops-public/circleci-orb-terraform-utils/compare/1.0.0...1.0.1) (2021-11-16)


### Bug Fixes

* Fix default tag for executor ([09fa1d4](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/09fa1d4b9f8f75941a376841918b539077828986))

# 1.0.0 (2021-11-16)


### Bug Fixes

* Fix parameters ([363add8](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/363add8b37ca80abed6e7ca9da9e4fe3e88a495c))


### Features

* Add initial sources ([117be98](https://github.com/trustedshops-public/circleci-orb-terraform-utils/commit/117be98533efcd7d44dc3b385732f30fbd18f128))
