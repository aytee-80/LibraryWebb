#!/bin/bash

export PATH=$GLASSFISH_HOME/bin:$PATH
PORT=${PORT:-8080}

# Start domain in background
asadmin start-domain domain1 &

# Wait for startup
echo "Waiting for domain to start..."
sleep 20

# Update port and address
asadmin --host localhost --port 4848 set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.port=$PORT
asadmin --host localhost --port 4848 set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.address=0.0.0.0

# Tail log
tail -f $GLASSFISH_HOME/domains/domain1/logs/server.log
