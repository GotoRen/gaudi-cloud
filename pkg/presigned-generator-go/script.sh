#!/bin/bash

SIGNED_URL=$(gcloud compute sign-url \
  "http://35.186.196.171/sample.jpg" \
  --key-name public-backend-bucket-key \
  --expires-in 30m \
  --key-file sign-url-key-file 2>/dev/null)

if [ $? -ne 0 ]; then
  echo "署名付きURLの生成に失敗しました"
  exit 1
fi

SIGNED_URL=$(echo $SIGNED_URL | grep -o 'http[^ ]*')
DEST_FILE="downloaded_sample.jpg"

curl -o $DEST_FILE $SIGNED_URL
if [ $? -eq 0 ]; then
  echo "画像がダウンロードされました: $DEST_FILE"
else
  echo "画像のダウンロードに失敗しました"
fi
