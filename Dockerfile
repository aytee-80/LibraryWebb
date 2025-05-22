# Use a minimal Debian base image
FROM debian:bullseye

# Set environment variables
ENV JAVA_VERSION=jdk1.8.0_202
ENV JAVA_HOME=/opt/$JAVA_VERSION
ENV PATH=$JAVA_HOME/bin:$PATH
ENV GLASSFISH_HOME=/opt/glassfish5/glassfish

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget unzip curl tar && \
    apt-get clean

# Install JDK 8u202
WORKDIR /opt
RUN wget https://mirrors.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz && \
    tar -xvzf jdk-8u202-linux-x64.tar.gz && \
    rm jdk-8u202-linux-x64.tar.gz

# Install GlassFish 5.0.1
WORKDIR /opt/glassfish5
RUN wget --no-check-certificate https://download.oracle.com/glassfish/5.0.1/nightly/glassfish-5.0.1-b05-01_19_2019.zip && \
    unzip glassfish-5.0.1-b05-01_19_2019.zip && \
    mv glassfish5/* . && \
    rm -rf glassfish5 && \
    rm glassfish-5.0.1-b05-01_19_2019.zip

# Copy WAR file into GlassFish autodeploy directory
COPY dist/Library.war $GLASSFISH_HOME/domains/domain1/autodeploy/app.war

# Add PostgreSQL JDBC driver
WORKDIR $GLASSFISH_HOME/lib/ext
RUN wget https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.24/postgresql-42.2.24.jar -O postgresql.jar

# Copy startup script
COPY startup.sh $GLASSFISH_HOME/startup.sh
RUN chmod +x $GLASSFISH_HOME/startup.sh

# Expose default HTTP port (Render sets PORT env var)
EXPOSE 8080

# Start GlassFish via startup script
CMD ["sh", "-c", "$GLASSFISH_HOME/startup.sh"]
