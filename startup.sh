#!/bin/bash

# Ensure asadmin is in PATH
export PATH=$GLASSFISH_HOME/bin:$PATH

# Use Render's assigned port, or fallback to 8080 locally
PORT=${PORT:-8080}

# Start the domain in background
asadmin start-domain domain1 &

# Wait for the domain to be ready
sleep 20

# Change port and bind address to be accessible externally
asadmin set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.port=$PORT
asadmin set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.address=0.0.0.0

# Tail the logs so Render keeps the container alive
tail -f $GLASSFISH_HOME/domains/domain1/logs/server.log
