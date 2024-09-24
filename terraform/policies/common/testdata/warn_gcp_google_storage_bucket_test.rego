package main

test_not_warn_google_storage_bucket_soft_delete_policy {
	msg := ""
	not warn[msg] with input as data.testdata.google_storage_bucket_with_soft_delete_policy
}

test_warn_google_storage_bucket_soft_delete_policy {
	msg := sprintf("WARN: google_storage_bucket '%s' の soft_delete_policy が設定されていません。詳細はこちら: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket#nested_soft_delete_policy", ["gaudi-test"])
	warn[msg] with input as data.testdata.google_storage_bucket_without_soft_delete_policy
}
