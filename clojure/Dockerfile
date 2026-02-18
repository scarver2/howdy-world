# clojure/Dockerfile

FROM clojure:temurin-21-lein

WORKDIR /app
COPY . .

RUN lein deps
RUN lein uberjar

EXPOSE 3000

CMD ["java", "-jar", "target/clojure-app-0.1.0-standalone.jar"]
