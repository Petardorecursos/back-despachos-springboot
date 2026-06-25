# Etapa 1: Construcción (Build)
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copiar el archivo de dependencias y el código fuente
COPY pom.xml .
COPY src ./src

# Compilar el proyecto omitiendo las pruebas unitarias para mayor velocidad
RUN mvn clean package -DskipTests

# Etapa 2: Entorno de ejecución (Runtime)
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Copiar el archivo .jar compilado desde la etapa anterior
COPY --from=build /app/target/*.jar app.jar

# Exponer el puerto específico de Despachos
EXPOSE 8081

ENTRYPOINT ["java", "-jar", "app.jar"]