# Go Fiber Notes

## Fiber v3 example
```go
// go-fiber/main.go

package main

import (
	"log"

	"github.com/gofiber/fiber/v3"
	"github.com/gofiber/template/html"
)

func main() {
	app := fiber.New(fiber.Config{
		Views: html.New("./views", ".html"),
	})

	app.Get("/", func(c fiber.Ctx) error {
		return c.Render("index", fiber.Map{
			"Title": "Howdy, World!",
		})
	})

	log.Fatal(app.Listen(":3000"))
}
```
