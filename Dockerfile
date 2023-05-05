FROM openjdk:21-slim AS base
WORKDIR /app
EXPOSE 8080

FROM openjdk:21-slim AS build
WORKDIR /src
COPY . .
RUN apt update
RUN apt upgrade -y
RUN apt install curl -y
RUN curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > lein
RUN chmod +x lein
RUN ./lein deps
RUN ./lein with-profile prod uberjar

FROM base AS final
WORKDIR /app
COPY --from=build /src/target/swarmpit.jar .
ENTRYPOINT ["java", "-jar", "swarmpit.jar"]

