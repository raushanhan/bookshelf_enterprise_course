FROM gradle:8.9-jdk17 AS build
WORKDIR /app
COPY . .

RUN gradle clean bootJar --no-daemon

FROM amazoncorretto:17.0.17-al2-generic
WORKDIR /app

COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]