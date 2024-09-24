package main

# ルール: google_storage_bucket リソースに soft_delete_policy が設定されていない場合に警告を出す
warn[msg] {
  resource := input.resource_changes[_]
  resource.type == "google_storage_bucket"
  not resource.change.after.soft_delete_policy

  msg := sprintf("WARN: google_storage_bucket '%s' の soft_delete_policy が設定されていません。詳細はこちら: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket#nested_soft_delete_policy", [resource.change.after.name])
}
