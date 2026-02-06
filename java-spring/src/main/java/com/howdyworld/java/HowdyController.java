// java-spring/src/main/java/com/howdyworld/HowdyController.java
package com.howdyworld.java;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HowdyController {
    @GetMapping(value = "/", produces = MediaType.TEXT_HTML_VALUE)
    public String howdy() {
        return """
                <!doctype html>
                <html lang="en">
                  <head>
                    <meta charset="utf-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1" />
                    <title>Howdy from Java Spring</title>
                  </head>
                  <body>
                    <h1>Howdy, World!</h1>
                  </body>
                </html>
                """;
    }

    // FUTURE
    // @GetMapping(value = "/healthz", produces = MediaType.TEXT_PLAIN_VALUE)
    // public String healthz() {
    // return "ok\n";
    // }
}