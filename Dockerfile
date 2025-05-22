# Use official Eclipse Temurin 8 JDK as base
FROM eclipse-temurin:8-jdk

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget unzip curl gettext-base && \
    apt-get clean

# Set working directory
WORKDIR /opt/glassfish5

# Download and extract GlassFish 5.0.1
RUN wget --no-check-certificate https://download.oracle.com/glassfish/5.0.1/nightly/glassfish-5.0.1-b05-01_19_2019.zip && \
    unzip glassfish-5.0.1-b05-01_19_2019.zip && \
    mv glassfish5/* . && \
    rm -rf glassfish5 && \
    rm glassfish-5.0.1-b05-01_19_2019.zip

# Set environment variables
ENV GLASSFISH_HOME=/opt/glassfish5/glassfish
ENV PATH=$GLASSFISH_HOME/bin:$PATH

# Copy WAR file into GlassFish autodeploy directory
COPY dist/Library.war $GLASSFISH_HOME/domains/domain1/autodeploy/app.war

# Add PostgreSQL JDBC driver
WORKDIR $GLASSFISH_HOME/lib/ext
RUN wget https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.24/postgresql-42.2.24.jar -O postgresql.jar

# Add startup script
WORKDIR /opt/glassfish5
COPY startup.sh ./startup.sh
RUN chmod +x ./startup.sh

# Expose port for Render (will be replaced by PORT env)
EXPOSE 8080

# Start script
CMD ["sh", "./startup.sh"]
