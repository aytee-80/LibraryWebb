# Use a minimal base image
FROM debian:bullseye

# Set environment variables
ENV JAVA_VERSION=jdk1.8.0_202
ENV JAVA_HOME=/opt/$JAVA_VERSION
ENV PATH=$JAVA_HOME/bin:$PATH

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget unzip curl tar && \
    apt-get clean

# Download and install JDK 8u202
WORKDIR /opt
RUN wget https://mirrors.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz && \
    tar -xvzf jdk-8u202-linux-x64.tar.gz && \
    rm jdk-8u202-linux-x64.tar.gz

# Set working directory for GlassFish
WORKDIR /opt/glassfish5

# Download and extract GlassFish 5.0.1
RUN wget --no-check-certificate https://download.oracle.com/glassfish/5.0.1/nightly/glassfish-5.0.1-b05-01_19_2019.zip && \
    unzip glassfish-5.0.1-b05-01_19_2019.zip && \
    mv glassfish5/* . && \
    rm -rf glassfish5 && \
    rm glassfish-5.0.1-b05-01_19_2019.zip

# Set GlassFish environment variables
ENV GLASSFISH_HOME=/opt/glassfish5/glassfish
ENV PATH=$GLASSFISH_HOME/bin:$PATH

# Copy WAR file into GlassFish autodeploy directory
COPY dist/Library.war $GLASSFISH_HOME/domains/domain1/autodeploy/app.war

# Add PostgreSQL JDBC driver
WORKDIR $GLASSFISH_HOME/lib/ext
RUN wget https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.24/postgresql-42.2.24.jar -O postgresql.jar

# Expose HTTP port
EXPOSE 8080

# Start GlassFish domain and follow server log
CMD ["sh", "-c", "asadmin start-domain domain1 && tail -f $GLASSFISH_HOME/domains/domain1/logs/server.log"]
