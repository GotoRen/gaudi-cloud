package main

import (
	"crypto/hmac"
	"crypto/sha1"
	"encoding/base64"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
	"time"
)

func generateSignUrl() string {
	expirationTime := time.Now().Add(time.Hour).Unix()

	urlStr := "http://35.186.196.171/sample.jpg"
	signSecretKeyName := "public-backend-bucket-key"
	signSecretKeyValue := "VFJ7hwxEBC3ELkhxfeRBBA"

	segments := []string{
		fmt.Sprintf("?Expires=%d", expirationTime),
		fmt.Sprintf("&KeyName=%s", signSecretKeyName),
	}

	signURL := urlStr + strings.Join(segments, "")

	signSecretKeyValue = strings.Replace(signSecretKeyValue, "-", "+", -1)
	signSecretKeyValue = strings.Replace(signSecretKeyValue, "_", "/", -1)
	switch len(signSecretKeyValue) % 4 {
	case 2:
		signSecretKeyValue += "=="
	case 3:
		signSecretKeyValue += "="
	}

	keyValue, err := base64.StdEncoding.DecodeString(signSecretKeyValue)
	if err != nil {
		fmt.Println("Error decoding secret key:", err)
		return ""
	}

	// Create the HMAC signature
	h := hmac.New(sha1.New, keyValue)
	h.Write([]byte(signURL))
	signature := base64.StdEncoding.EncodeToString(h.Sum(nil))

	// Convert to URL-safe base64 format
	signature = strings.Replace(signature, "+", "-", -1)
	signature = strings.Replace(signature, "/", "_", -1)
	signature = strings.Replace(signature, "=", "", -1)

	segments = append(segments, fmt.Sprintf("&Signature=%s", signature))

	signedQuery := strings.Join(segments, "")

	return urlStr + signedQuery
}

func downloadImage(url string, filename string) error {
	// 新しいHTTPリクエストを作成
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return err
	}

	// Clientを使ってリクエストを送信
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	// リクエストのヘッダを出力
	fmt.Println("Request Headers:")
	for key, value := range req.Header {
		fmt.Printf("%s: %s\n", key, value)
	}

	// レスポンスのヘッダを出力
	fmt.Println("Response Headers:")
	for key, value := range resp.Header {
		fmt.Printf("%s: %s\n", key, value)
	}

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("Failed to download image: status code %d", resp.StatusCode)
	}

	out, err := os.Create(filename)
	if err != nil {
		return err
	}
	defer out.Close()

	_, err = io.Copy(out, resp.Body)
	if err != nil {
		return err
	}

	return nil
}

func main() {
	signedURL := generateSignUrl()
	fmt.Println("Signed URL:", signedURL)

	err := downloadImage(signedURL, "downloaded_image.png")
	if err != nil {
		fmt.Println("Error downloading image:", err)
	} else {
		fmt.Println("Image successfully downloaded.")
	}
}
