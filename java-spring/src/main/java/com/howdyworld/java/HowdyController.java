// java-spring/src/main/java/com/howdyworld/HowdyController.java
package com.howdyworld.java;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HowdyController {
    @GetMapping(value = "/", produces = MediaType.TEXT_PLAIN_VALUE)
    public String howdy() {
        return "Howdy, World!\n";
    }
}
