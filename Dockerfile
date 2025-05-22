# ✅ Use Ubuntu 20.04 as base
FROM ubuntu:20.04

# ✅ Install dependencies including JDK 8
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    wget unzip openjdk-8-jdk curl ca-certificates && \
    apt-get clean

# ✅ Set environment variables for Java
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# ✅ Set working directory
WORKDIR /opt

# ✅ Download and extract GlassFish 5.0.1
RUN wget https://download.oracle.com/glassfish/5.0.1/release/glassfish-5.0.1.zip && \
    unzip glassfish-5.0.1.zip && \
    rm glassfish-5.0.1.zip

# ✅ Set GlassFish environment variables
ENV GLASSFISH_HOME=/opt/glassfish5/glassfish
ENV PATH=$GLASSFISH_HOME/bin:$PATH

# ✅ Copy WAR file to GlassFish autodeploy folder
COPY dist/Library.war $GLASSFISH_HOME/domains/domain1/autodeploy/app.war

# ✅ Add PostgreSQL JDBC Driver into GlassFish lib
# Download and install PostgreSQL driver directly into ext folder
WORKDIR $GLASSFISH_HOME/lib/ext
RUN wget https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.3/postgresql-42.7.3.jar  -O postgresql.jar

# ✅ Expose the default HTTP port
EXPOSE 8080

# ✅ Start GlassFish domain in foreground (no && tail needed)
CMD ["sh", "-c", "$GLASSFISH_HOME/bin/asadmin start-domain --verbose"]
