package main

import (
	"log"

	"github.com/CyberAgentHack/24fresh_g_spark-link_cloud/pkg/api/internal"
)

func main() {
	log.Print("Hello, World!")

	str1 := internal.GetHello()
	log.Println("api: ", str1)
}
