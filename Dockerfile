# Use official Eclipse Temurin 8 JDK as base
FROM eclipse-temurin:8-jdk

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget unzip curl && \
    apt-get clean

# Set working directory
WORKDIR /opt/glassfish5

# Download and extract GlassFish 5.0.1
RUN wget --no-check-certificate https://github.com/eclipse-ee4j/glassfish/releases/download/5.0.1/glassfish-5.0.1.zip  && \
    unzip glassfish-5.0.1.zip && \
    rm glassfish-5.0.1.zip

# Set environment variables
ENV GLASSFISH_HOME /opt/glassfish5/glassfish
ENV PATH=$GLASSFISH_HOME/bin:$PATH

# Copy WAR file
COPY dist/Library.war $GLASSFISH_HOME/domains/domain1/autodeploy/app.war

# Add PostgreSQL JDBC driver
WORKDIR $GLASSFISH_HOME/lib/ext
RUN wget https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.24/postgresql-42.2.24.jar  -O postgresql.jar

# Expose HTTP port
EXPOSE 8080

# Start domain and tail logs
CMD ["asadmin", "start-domain", "domain1", "&&", "tail", "-f", "$GLASSFISH_HOME/glassfish/domains/domain1/logs/server.log"]
