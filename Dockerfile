# Stage 1: Build the Java app
FROM maven:3.8.3-openjdk-17 AS build

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create runtime image
FROM openjdk:17-jdk-slim

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
