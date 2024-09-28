# Étape 1 : Builder le projet Maven
FROM maven:3.9.2 AS build

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers du projet Maven dans l'image
COPY pom.xml .
COPY src ./src

# Compiler le projet avec Maven
RUN mvn clean package -DskipTests

# Étape 2 : Créer une image légère pour exécuter l'application
FROM openjdk:17-jdk-slim

# Créer un répertoire pour l'application
WORKDIR /app

# Copier le fichier JAR généré par Maven depuis l'étape précédente
COPY --from=build /app/target/*.jar app.jar

# Exposer le port 80
EXPOSE 80

# Exécuter l'application sur le port 80
CMD ["java", "-jar", "app.jar", "--server.port=80"]
