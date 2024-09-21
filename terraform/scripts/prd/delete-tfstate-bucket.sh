#!/bin/bash

ENVIRONMENT="prd"

PROJECT_ID="gcp-gaudi-${ENVIRONMENT}"
BUCKET_NAME="gaudi-${ENVIRONMENT}-terraform-tfstate"

# バケットの存在確認
echo "Checking for the existence of the bucket ${BUCKET_NAME}..."
if gsutil ls -p ${PROJECT_ID} | grep "gs://${BUCKET_NAME}/"; then
  echo "Bucket ${BUCKET_NAME} exists. Proceeding with deletion..."
else
  echo "Error: Bucket ${BUCKET_NAME} does not exist. Exiting..."
  exit 1
fi

# バケットの内容を確認
echo "Listing contents of bucket ${BUCKET_NAME}..."
gsutil ls gs://${BUCKET_NAME}

# バケット削除の確認
read -p "Are you sure you want to delete the bucket ${BUCKET_NAME} and all its contents? (yes/no): " confirm
if [[ "$confirm" != "yes" ]]; then
  echo "Bucket deletion cancelled."
  exit 1
fi

# オブジェクトを全て削除
echo "Deleting all contents of bucket ${BUCKET_NAME}..."
gsutil -m rm -r gs://${BUCKET_NAME}/*

# バケット自体を削除
echo "Deleting bucket ${BUCKET_NAME}..."
gsutil rb gs://${BUCKET_NAME}

# 確認メッセージ出力
echo "GCS Bucket ${BUCKET_NAME} and all its contents have been deleted successfully."
