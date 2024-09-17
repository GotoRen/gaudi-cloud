package main

import (
	"log"

	"github.com/gaudi-organization/gaudi-cloud/pkg/api/internal"
)

func main() {
	log.Print("Hello, World!")

	str1 := internal.GetHello()
	log.Println("api: ", str1)
}
