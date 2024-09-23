locals {
  environment_array = [
    "dev",        // 開発環境
    "stg",        // ステージング環境
    "prd",        // 本番環境
    "load",       // 負荷試験環境
    "playground", // 検証環境
    "poc",        // 概念実証環境
  ]

  owner_array = [
    "web",            // Web
    "native",         // ネイティブ
    "backend",        // バックエンド
    "ml",             // ML/DS
    "cloud-platform", // クラウドプラットフォーム
    "sre",            // SRE
  ]
}

output "labels" {
  value = tomap({
    "resource-env"        = var.env,
    "resource-name"       = var.name,
    "resource-owner"      = var.owner,
    "resource-group"      = var.group,
    "resource-subgroup"   = var.subgroup,
    "resource-tags"       = var.tags,
    "resource-managed-by" = "terraform", // Module 利用者による上書を禁止とする
  })

  precondition {
    condition     = contains(local.environment_array, var.env)
    error_message = "Valiable 'env' は ${join(", ", local.environment_array)} のいずれかを指定してください"
  }

  precondition {
    condition     = contains(local.owner_array, var.owner)
    error_message = "Valiable 'owner' は ${join(", ", local.owner_array)} のいずれかを指定してください"
  }
}
