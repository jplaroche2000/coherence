#!/bin/bash
# Run the custom ASCII Coherence dashboard.
#
# @author Jean-Philippe Laroche / May 25th 2017 / for Rogers servers

echo "Running Dashboard"

COHERENCE_DOMAIN=/u01/oracle/domain

EXECUTE="$JAVA_HOME/bin/java -cp $CLASS_PATH:.:${COHERENCE_DOMAIN}/lib/*:${COHERENCE_DOMAIN}/libCache/*:${COHERENCE_HOME}/lib/* com.rogers.rci.dg.jmx.script.Dashboard $@"

$EXECUTE
