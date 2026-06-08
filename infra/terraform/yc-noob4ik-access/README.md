# yc-noob4ik-access

Bootstrap workspace — создаёт сервисный фолдер `access` и всё необходимое для управления инфраструктурой облака **noob4ik-sandbox** через Terraform.

## Архитектура

```
noob4ik-sandbox (cloud)
├── access/                        ← этот workspace
│   ├── sa-terraform               SA с editor + resource-manager.admin на облако
│   └── noob4ik-sandbox-tfstate    бакет для remote state всех workspace
├── sandbox-lab/                   ← workload folder
└── <other-folders>/               ← будущие фолдеры, покрываются теми же правами SA
```

## Что создаётся

| Ресурс | Где | Описание |
|--------|-----|----------|
| `yandex_resourcemanager_folder` "access" | cloud | Сервисный фолдер |
| `yandex_iam_service_account` "sa-terraform" | access folder | Terraform runner |
| `editor` на облако | cloud level | Управление ресурсами во всех фолдерах |
| `resource-manager.admin` на облако | cloud level | Управление IAM-биндингами через TF |
| `storage.admin` на access folder | access folder | Управление бакетом состояния |
| `yandex_storage_bucket` tfstate | access folder | Remote state с версионированием |

## Bootstrap (применяется один раз, вручную)

```bash
cd infra/terraform/yc-noob4ik-access

# Аутентификация от пользователя с admin-правами на облако
export YC_TOKEN=$(yc iam create-token)

terraform init    # state пока локальный (no backend yet)
terraform apply

# Сохранить ключи (добавить в CI/CD secrets / переменные окружения)
terraform output -raw s3_access_key
terraform output -raw s3_secret_key
```

> После первого `apply` локальный state можно перенести в созданный бакет:
> ```bash
> # добавить backend.tf (см. output backend_snippet), затем:
> terraform init -migrate-state
> ```

## Remote state в других workspace

```hcl
# backend.tf
terraform {
  backend "s3" {
    endpoint = "https://storage.yandexcloud.net"
    bucket   = "noob4ik-sandbox-tfstate"
    region   = "ru-central1"
    key      = "sandbox-lab/terraform.tfstate"   # путь уникален для каждого workspace

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
```

```bash
export AWS_ACCESS_KEY_ID=<s3_access_key>
export AWS_SECRET_ACCESS_KEY=<s3_secret_key>
terraform init
```
