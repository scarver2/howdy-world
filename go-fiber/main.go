// go-fiber/main.go

package main

import (
	"github.com/gofiber/fiber/v2"
)

func main() {
	app := fiber.New()

	app.Get("/", func(c *fiber.Ctx) error {
		return c.Type("html").SendString(`
<!DOCTYPE html>
<html>
<head>
  <title>Howdy from Go Fiber</title>
</head>
<body>
  <h1>Howdy, World!</h1>
</body>
</html>
`)
	})

	app.Listen(":3000")
}
