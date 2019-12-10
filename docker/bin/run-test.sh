#!/bin/bash
# Run the custom ASCII Coherence dashboard.
#
# @author Jean-Philippe Laroche / May 25th 2017 / for Rogers servers

echo "Running test"

COHERENCE_DOMAIN=/u01/oracle/domain

IP_ADDRESS=`ifconfig eth0 | grep inet | awk '{ print $2 }'`

EXECUTE="$JAVA_HOME/bin/java -cp $CLASS_PATH:.:${COHERENCE_DOMAIN}/test:${COHERENCE_DOMAIN}/lib/*:${COHERENCE_DOMAIN}/libCache/*:${COHERENCE_HOME}/lib/* com.telus.poc.coherence.client.remote.ShowCustomerInfosGeneric $IP_ADDRESS $@"

$EXECUTE
