#!/bin/bash

# Add asadmin to PATH
export PATH=$GLASSFISH_HOME/bin:$PATH

# Get Render-assigned port or default to 8080
PORT=${PORT:-8080}

# Start domain in background
asadmin start-domain domain1 &

# Wait for domain to boot
sleep 20

# Now update listener config explicitly via localhost:4848
asadmin --host localhost --port 4848 set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.port=$PORT
asadmin --host localhost --port 4848 set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.address=0.0.0.0

# Tail logs to keep container running
tail -f $GLASSFISH_HOME/domains/domain1/logs/server.log
