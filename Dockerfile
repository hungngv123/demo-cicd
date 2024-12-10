FROM openjdk:17-jdk-slim
LABEL authors="hunghd0502"
WORKDIR /app
VOLUME /tmp
COPY target/*.jar /app/app.jar
ENTRYPOINT ["java","-jar","/app/app.jar"]