const { add, getUnixTime } = require("date-fns");
const { createHmac } = require("crypto");
const axios = require("axios");
const fs = require("fs");
path = require("path");

function generateSignUrl() {
  // URL の有効期限を 1 時間に設定
  const unixTimestamp = getUnixTime(add(new Date(), { hours: 1 }));

  const url = "http://35.186.196.171/sample.jpg";
  const signSecretKeyName = "public-backend-bucket-key";
  const signSecretKeyValue = "VFJ7hwxEBC3ELkhxfeRBBA";

  const segments = [
    `?Expires=${unixTimestamp}`,
    `&KeyName=${signSecretKeyName}`,
  ];

  const signURL = `${url}${segments.join("")}`;
  const keyValue = Buffer.from(signSecretKeyValue, "base64");

  const signature = createHmac("sha1", keyValue)
    .update(signURL)
    .digest("base64")
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=/g, "");

  segments.push(`&Signature=${signature}`);

  const signedQuery = segments.join("");

  return `${url}${signedQuery}`;
}

async function downloadFile(url, outputLocationPath) {
  const writer = fs.createWriteStream(outputLocationPath);

  const response = await axios({
    url,
    method: "GET",
    responseType: "stream",
  });

  response.data.pipe(writer);

  return new Promise((resolve, reject) => {
    writer.on("finish", resolve);
    writer.on("error", reject);
  });
}

// 署名付き URL の生成
const signedURL = generateSignUrl();
console.log("Signed URL:", signedURL);

// ダウンロードするファイルのパスを指定
const outputLocationPath = path.resolve(__dirname, "downloaded_sample.jpg");

// ダウンロード実行
downloadFile(signedURL, outputLocationPath)
  .then(() => {
    console.log(`File downloaded to ${outputLocationPath}`);
  })
  .catch((err) => {
    console.error("Error downloading the file:", err);
  });
