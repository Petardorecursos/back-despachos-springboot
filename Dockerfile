# Etapa 1: Construcción (Build)
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Optimización: Descargar dependencias primero para aprovechar la caché de Docker
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiar el código fuente y compilar
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Entorno de ejecución (Runtime) - Endurecido y Minimalista
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

# Exponer el puerto
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
