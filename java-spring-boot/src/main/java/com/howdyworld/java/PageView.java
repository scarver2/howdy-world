// java-spring-boot/src/main/java/com/howdyworld/java/PageView.java
package com.howdyworld.java;

public class PageView {
    private final String title;
    private final String heading;
    private final String content;

    // Full constructor (no defaults)
    public PageView(String title, String heading, String content) {
        this.title = (title == null || title.isBlank()) ? "Howdy from Java Spring!" : title;
        this.heading = (heading == null || heading.isBlank()) ? "Howdy, World!" : heading;
        this.content = (content == null) ? "" : content;
    }

    // Convenience constructor with defaults
    public PageView() {
        this("Howdy from Java Spring Boot!", "Howdy, World!", "");
    }

    public String getTitle() {
        return title;
    }

    public String getHeading() {
        return heading;
    }

    public String getContent() {
        return content;
    }
}
