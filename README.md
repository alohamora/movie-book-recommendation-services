# movie-book-recommendation-services
A movie and book recommendation website with collaborative filtering which generates recommendations based on user's rating in both the domains(movies and books)

# Installation instructions
## backend
- Install java 8: `sudo apt-get install openjdk-8-jdk`
- Install maven: `sudo apt install maven`
- Set `JAVA_HOME` by adding the following command in `.bashrc` file  : `export JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-amd64"`
- Restart the terminal after installation

## frontend
- Go into my-app directory: `cd frontend/my-app`
- run `npm install`

# Running instructions
## backend
- Go into backend directory: `cd backend/`
- Go into config service directory: `cd config-service/`
- start config service: `mvn spring-boot:run`
- Go into eureka service directory: `cd eureka-service`
- Start eureka service: `mvn spring-boot:run`
- Start all other services similarly
- <b>NOTE</b> - Start the config service first, then eureka service and then all other services

## frontend
- Go into my-app directory: `cd frontend/my-app`
- run: `npm start`
