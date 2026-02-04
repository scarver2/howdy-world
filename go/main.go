// go/main.go
package main

import (
	"html/template"
	"log"
	"net/http"
	"os"
)

type PageData struct {
	Title   string
	Heading string
}

var pageTmpl = template.Must(template.New("page").Parse(`<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>{{.Title}}</title>
</head>
<body>
<h1>{{.Heading}}</h1>
</body>
</html>
`))

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	mux := http.NewServeMux()

	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/html; charset=utf-8")

		data := PageData{
			Title:   "Howdy from Go",
			Heading: "Howdy, World!",
		}

		// Execute writes directly to the response writer.
		if err := pageTmpl.Execute(w, data); err != nil {
			// If template execution fails after headers are written, just log it.
			log.Printf("template execute error: %v", err)
		}
	})

	addr := ":" + port
	log.Printf("Go service listening on %s", addr)
	log.Fatal(http.ListenAndServe(addr, mux))
}
