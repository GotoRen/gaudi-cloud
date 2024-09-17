package internal_test

import (
	"testing"

	"github.com/gaudi-organization/gaudi-cloud/pkg/api/internal"
)

func TestHello(t *testing.T) {
	str := "Hello, World!"
	if str == internal.GetHello() {
		t.Fatal("test failed")
	} else {
		t.Log("test successful")
	}
}
