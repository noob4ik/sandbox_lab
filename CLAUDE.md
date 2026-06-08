# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A monorepo for sandbox lab infrastructure — cloud-native homelab experiments deployed on **Yandex Cloud** (account: `noob4ik-sanbox`, ID: `b1gr6l37afpf886jucaj`).

## Repository Structure

```
infra/
├── ansible/       # Ansible playbooks (not yet populated)
├── flux/          # Flux CD GitOps configuration (not yet populated)
└── terraform/
    └── yc-noob4ik-sanbox/   # Terraform configs for Yandex Cloud
```

## Infrastructure Stack

- **Terraform** — cloud resource provisioning on Yandex Cloud
- **Ansible** — configuration management and provisioning
- **Flux CD** — GitOps continuous delivery for Kubernetes

## Terraform Conventions

When adding Terraform code under `infra/terraform/`, use standard Terraform CLI:

```bash
cd infra/terraform/yc-noob4ik-sanbox
terraform init
terraform plan
terraform apply
```

Use `terraform fmt` to format HCL files before committing. Prefer separate `.tf` files by resource type (`main.tf`, `variables.tf`, `outputs.tf`, `providers.tf`).

## Yandex Cloud Provider

Use the [Yandex Cloud Terraform provider](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs). Credentials are expected via environment variables (`YC_TOKEN` or `YC_SERVICE_ACCOUNT_KEY_FILE`), not hardcoded.
