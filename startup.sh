#!/bin/bash

export PATH=$GLASSFISH_HOME/bin:$PATH

# Start the domain
asadmin start-domain domain1

# Tail logs to keep container alive
tail -f $GLASSFISH_HOME/domains/domain1/logs/server.log
