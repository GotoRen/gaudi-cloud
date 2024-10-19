import React, { useState, useEffect } from "react";
import axios from "axios";

// CORS エラーを避けるためにプロキシを利用
const App: React.FC = () => {
  const [imageSrc, setImageSrc] = useState<string | null>(null);
  const [headers, setHeaders] = useState<Record<string, string> | null>(null);

  const fetchImage = async (url: string) => {
    try {
      console.log(`Fetching image from: ${url}`);
      const response = await axios.get(url, { responseType: "blob" });

      console.log(`Response status: ${response.status}`);

      // HTTP ステータスコードをチェック
      if (response.status !== 200) {
        throw new Error(
          `Failed to fetch image, status code: ${response.status}`
        );
      }

      // レスポンスデータからオブジェクトURLを作成
      const imageUrl = URL.createObjectURL(response.data);
      setImageSrc(imageUrl);

      // レスポンスヘッダを設定
      setHeaders(response.headers as Record<string, string>);
      console.log("Response Headers:", response.headers);

      // キャッシングヘッダをチェック
      const age = response.headers["age"];
      const xCache = response.headers["x-cache"];

      // キャッシング情報を出力
      if (age && xCache) {
        console.log(`CDN Cache Age: ${age} seconds`);
        console.log(`CDN Cache Status: ${xCache}`);
      } else {
        console.log(
          "CDN Caching Information not found in the response headers."
        );
      }
    } catch (error) {
      if (axios.isAxiosError(error)) {
        console.error("Axios error:", error.message);
        if (error.response) {
          console.error("Response status:", error.response.status);
          console.error("Response data:", error.response.data);
        } else if (error.request) {
          console.error("Request made, no response:", error.request);
        }
      } else if (error instanceof Error) {
        console.error("General error:", error.message);
      } else {
        console.error("Unknown error:", error);
      }
    }
  };

  useEffect(() => {
    const cdnURL = "/sample.jpg"; // プロキシを使うためにURLを変更 package.json - "proxy": "http://35.186.196.171"
    fetchImage(cdnURL);
  }, []);

  return (
    <div>
      <h1>Cache Checker</h1>
      {headers && (
        <div>
          <h2>Headers:</h2>
          <pre>{JSON.stringify(headers, null, 2)}</pre>
        </div>
      )}
      {imageSrc ? (
        <img src={imageSrc} alt="Fetched" />
      ) : (
        <p>Loading image...</p>
      )}
    </div>
  );
};

export default App;
