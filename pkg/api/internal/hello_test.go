package internal_test

import (
	"testing"

	"github.com/CyberAgentHack/24fresh_g_spark-link_cloud/pkg/api/internal"
)

func TestHello(t *testing.T) {
	str := "Hello, World!"
	if str != internal.GetHello() {
		t.Fatal("test failed")
	} else {
		t.Log("test successful")
	}
}
