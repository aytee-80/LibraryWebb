#!/bin/bash

# Set PATH to include asadmin
export PATH=$GLASSFISH_HOME/bin:$PATH

# Use PORT from env or default to 8080
PORT=${PORT:-8080}

# Start the domain first
asadmin start-domain domain1

# Set the HTTP listener port to the PORT value
asadmin set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.port=$PORT

# Tail the server log to keep container alive
tail -f $GLASSFISH_HOME/domains/domain1/logs/server.log
