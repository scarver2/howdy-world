// java-spring-boot/src/main/java/com/howdyworld/java/HowdyController.java
package com.howdyworld.java;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HowdyController {

  @GetMapping("/")
  public String howdy(Model model) {
    model.addAttribute("page", new PageView("Howdy from Java Spring", "Howdy, World!", ""));
    return "index"; // renders src/main/resources/templates/index.html
  }

  // Lock-in: keep /healthz available but not active yet.
  // @GetMapping("/healthz")
  // @ResponseBody
  // public String healthz() {
  // return "ok\n";
  // }
}
