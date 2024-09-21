#/bin/bash

ENVIRONMENT="prd"

PROJECT_ID="gcp-gaudi-${ENVIRONMENT}"
REGION="asia-northeast1"
BUCKET_NAME="gaudi-${ENVIRONMENT}-terraform-tfstate"

OWNER="cloud-platform"
MANAGED_BY="shellscript"

### バケット作成
gsutil mb -p ${PROJECT_ID} -c STANDARD -l ${REGION} -b on gs://${BUCKET_NAME}

### 非公開設定
gsutil iam ch -d allUsers gs://${BUCKET_NAME}
gsutil iam ch -d allAuthenticatedUsers gs://${BUCKET_NAME}

### バージョニング設定
gsutil versioning set on gs://${BUCKET_NAME}

### タグ付与（GCSバケットのラベリングとして設定）
gcloud alpha storage buckets update gs://${BUCKET_NAME} \
  --update-labels resource-name=${BUCKET_NAME},resource-owner=${OWNER},resource-managed-by=${MANAGED_BY},resource-env=${ENVIRONMENT}

### 確認メッセージ出力
echo "GCS Bucket $(gsutil ls) has been created and configured successfully."
