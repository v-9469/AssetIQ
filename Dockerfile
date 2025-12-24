# --- Stage 1: Build ---
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# Copy maven executable and pom first for better caching
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# Fix line endings and make mvnw executable, then download dependencies
RUN apt-get update && apt-get install -y dos2unix && \
    dos2unix ./mvnw && \
    chmod +x ./mvnw && \
    apt-get remove -y dos2unix && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN ./mvnw dependency:go-offline

# Copy source and build
COPY src ./src
RUN ./mvnw clean package -DskipTests

# --- Stage 2: Runtime ---
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Create a non-root user for security
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

COPY --from=build /app/target/*.jar app.jar

# JVM optimizations for Containers & Virtual Threads
ENV JAVA_OPTS="-XX:+UseParallelGC -XX:MaxRAMPercentage=75.0 -Dspring.threads.virtual.enabled=true"

EXPOSE 8080
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]