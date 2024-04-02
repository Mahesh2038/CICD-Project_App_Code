FROM openjdk:8
ADD <Path where JAR has generated> appArtifact.jar 
ENTRYPOINT ["java", "-jar", "appArtifact.jar"]