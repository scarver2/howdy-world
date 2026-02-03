// go/main.go
package main

import (
	"log"
	"net/http"
	"os"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	mux := http.NewServeMux()

	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// Keep it simple, "Hello World"-style.
		w.Header().Set("Content-Type", "text/plain; charset=utf-8")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte("Howdy, World!\n"))
	})

	addr := ":" + port
	log.Printf("Go service listening on %s", addr)
	log.Fatal(http.ListenAndServe(addr, mux))
}
