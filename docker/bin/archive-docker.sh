#!/bin/bash
# Run the custom ASCII Coherence dashboard.
#
# @author Jean-Philippe Laroche

echo "Taking Snapshot $@"

COHERENCE_DOMAIN=/u01/oracle/domain

EXECUTE="$JAVA_HOME/bin/java -cp $CLASS_PATH:.:${COHERENCE_DOMAIN}/lib/*:${COHERENCE_DOMAIN}/libCache/*:${COHERENCE_HOME}/lib/* com.telus.dg.jmx.script.Archive $@" 

$EXECUTE

