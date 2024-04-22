FROM openjdk:11 AS build_backend

WORKDIR /app

COPY . .

RUN ./mvnw clean package \
    && rm -rf src resources mvnw* pom.xml .mvn

FROM openjdk:11

# See docker-compose.yml: line 18 
RUN apt update \
    && apt install curl -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=build_backend /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT [ "java","-jar","app.jar" ]