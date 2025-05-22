#!/bin/bash

# Use PORT from environment or default to 8080
PORT=${PORT:-8080}

# Update HTTP listener port to match PORT env variable
asadmin start-domain domain1

asadmin set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.port=$PORT

# Keep server running and log output
tail -f $GLASSFISH_HOME/domains/domain1/logs/server.log
