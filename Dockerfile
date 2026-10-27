FROM eclipse-temurin:21-jdk-jammy AS build
WORKDIR /workspace
COPY gradlew gradlew.bat settings.gradle build.gradle ./
COPY gradle ./gradle
RUN chmod +x gradlew
COPY src ./src
RUN ./gradlew --no-daemon clean test bootJar

FROM eclipse-temurin:21-jre-jammy AS runtime
WORKDIR /app
RUN groupadd --system student && useradd --system --gid student student
COPY --from=build --chown=student:student /workspace/build/libs/student-api.jar /app/student-api.jar
USER student
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/student-api.jar"]
