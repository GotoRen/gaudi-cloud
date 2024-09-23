# Gaudi Terraform

## ローカル環境に GCP プロジェクトを設定する

```shell
### OAuth ログイン
$ gcloud auth login

### 確認
$ gcloud auth list
           Credentialed Accounts
ACTIVE  ACCOUNT
*       <YOUR_EMAIL>

### GCP プロジェクトの構成を追加
$ gcloud config configurations create gaudi

### プロジェクトをセット
$ gcloud config set project <YOUR_PROJECT>

### アカウントをセット
$ gcloud config set account <YOUR_EMAIL>

### 確認
$ gcloud config get-value project
Your active configuration is: [gaudi]
<YOUR_PROJECT>

$ gcloud config configurations list
NAME           IS_ACTIVE  ACCOUNT                               PROJECT        COMPUTE_DEFAULT_ZONE  COMPUTE_DEFAULT_REGION
gaudi          True       <YOUR_EMAIL>                   <YOUR_PROJECT>
```

## 【必読】ルール

1. 公式推奨に則り tfstate 管理用の GCS バケットは CLI（`gsutil`）で作成 [^1]

> To migrate your state away from using customer-supplied encryption keys or change the key used by your backend, you need to perform a rewrite (gsutil CLI) or cp (gcloud CLI) operation to remove use of the old customer-supplied encryption key on your state file. Once you remove the encryption, you can successfully run terraform init -migrate-state with your new backend configuration.

2. 全てのマネージドサービスに以下のタグおよびラベルを付与するものとする。

| Key                   | 適用事項 | Value                                                                 |
| :-------------------- | :------- | :-------------------------------------------------------------------- |
| `resource-name`       | 必須     | リソース名                                                            |
| `resource-owner`      | 必須     | リソースの管理スコープ：web, native, backend, ml, cloud-platform, sre |
| `resource-managed-by` | 必須     | リソースの管理方法：terraform, shellscript, argocd, console           |
| `resource-env`        | 必須     | 運用環境：dev, stg, prd, load, playground, poc                        |

## GKE 構築手順

```shell
### GKE クラスタに接続
$ gcloud container clusters get-credentials <YOUR_CLUSTER_NAME> --region <YOUR_REGION> --project <YOUR_PROJECT>
```

## 参考

[^1]: https://developer.hashicorp.com/terraform/language/backend/gcs#customer-supplied-encryption-keys
