# ✅ Use Ubuntu 20.04 as base
FROM ubuntu:20.04

# ✅ Install dependencies (no OpenJDK)
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    wget unzip curl ca-certificates && \
    apt-get clean

FROM eclipse-temurin:8-jdk
RUN apt-get update && \
    apt-get install -y wget unzip curl && \
    apt-get clean

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

# ✅ Add PostgreSQL JDBC Driver (42.2.5)
WORKDIR $GLASSFISH_HOME/lib/ext
RUN wget https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.5/postgresql-42.2.5.jar -O postgresql.jar

# ✅ Expose HTTP port
EXPOSE 8080

# ✅ Start GlassFish in foreground
CMD ["sh", "-c", "$GLASSFISH_HOME/bin/asadmin start-domain --verbose"]
