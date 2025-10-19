FROM gradle:9.1.0-jdk25 AS build
WORKDIR /apa

FROM eclipse-temurin:25-jre-alpine AS application
WORKDIR /app

ENTRYPOINT ["java"]
