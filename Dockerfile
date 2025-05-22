# Use official Eclipse Temurin 8 JDK as base
FROM eclipse-temurin:8-jdk

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget unzip maven curl && \
    apt-get clean

# Set working directory
WORKDIR /usr/src/myapp

# Copy source code
COPY . .

# Build WAR file
RUN mvn clean package

# Install GlassFish
WORKDIR /opt/glassfish5
RUN wget --no-check-certificate https://download.oracle.com/glassfish/5.0.1/nightly/glassfish-5.0.1-b05-01_19_2019.zip  && \
    unzip glassfish-5.0.1-b05-01_19_2019.zip && \
    mv glassfish5/* . && \
    rm -rf glassfish5 glassfish-5.0.1-b05-01_19_2019.zip

# Set environment variables
ENV GLASSFISH_HOME=/opt/glassfish5/glassfish
ENV PATH=$GLASSFISH_HOME/bin:$PATH

# Copy built WAR into autodeploy
COPY dist/Library.war $GLASSFISH_HOME/domains/domain1/autodeploy/app.war

# Add PostgreSQL JDBC driver
WORKDIR $GLASSFISH_HOME/lib/ext
RUN wget https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.24/postgresql-42.2.24.jar  -O postgresql.jar

# Expose HTTP port
EXPOSE 8080

# Start domain and follow logs
CMD ["sh", "-c", "asadmin start-domain domain1 && tail -f $GLASSFISH_HOME/domains/domain1/logs/server.log"]
