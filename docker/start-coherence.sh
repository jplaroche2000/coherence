#!/usr/bin/env sh

#!/bin/sh -e -x -u

trap "echo TRAPed signal" HUP INT QUIT KILL TERM


if [ "${NIC}" != "eth1" ]
then
	IP_ADDRESS=`ifconfig eth0 | grep inet | awk '{ print $2 }'`
else
	IP_ADDRESS=`ifconfig eth1 | grep inet | awk '{ print $2 }'`
fi

if [ -z "${NODE_NAME}" ]
then
	MACHINE_NAME=$HOSTNAME
else
	MACHINE_NAME=$NODE_NAME
fi

PID=$$

main() {

    COMMAND=server
    SCRIPT_NAME=$(basename "${0}")
    MAIN_CLASS="com.tangosol.net.DefaultCacheServer"

    case "${1}" in
        server) COMMAND=${1}; shift ;;
        proxy) COMMAND=${1}; shift ;;
        console) COMMAND=${1}; shift ;;
        queryplus) COMMAND=queryPlus; shift ;;
        mbean) COMMAND=mbean; shift ;;
        help) COMMAND=${1}; shift ;;
    esac

    case ${COMMAND} in
        server) server ;;
        proxy) proxy ;;
        console) console ;;
        queryPlus) queryPlus ;;
        mbean) mbean ;;
        help) usage; exit ;;
        *) server ;;
    esac
}

# ---------------------------------------------------------------------------
# Display the help text for this script
# ---------------------------------------------------------------------------
usage() {
    echo "Usage: ${SCRIPT_NAME} [type] [args]"
    echo ""
    echo "type: - the type of process to run, must be one of:"
    echo "    server  - runs a storage enabled DefaultCacheServer"
    echo "              (server is the default if type is omitted)"
    echo "    proxy   - runs a storage disabled DefaultCacheServer"
    echo "    mbean   - runs a dedicated mbean connector node"
    echo "    console - runs a storage disabled Coherence console"
    echo "    query   - runs a storage disabled QueryPlus session"
    echo "    help    - displays this usage text"
    echo ""
    echo "args: - any subsequent arguments are passed as program args to the main class"
    echo ""
    echo "Environment Variables: The following environment variables affect the script operation"
    echo ""
    echo "JAVA_OPTS       - this environment variable adds Java options to the start command,"
    echo "                  for example memory and other system properties"
    echo ""
    echo "COH_WKA         - Sets the WKA address to use to discover a Coherence cluster."
    echo ""
    echo "COH_EXTEND_PORT - If set the Extend Proxy Service will listen on this port instead"
    echo "                  of the default ephemeral port."
    echo ""
    echo "Any jar files added to the /lib folder will be pre-pended to the classpath."
    echo "The /conf folder is on the classpath so any files in this folder can be loaded by the process."
    echo ""
}

server() {
    COH_OPTS="-Dcoherence.localstorage=true -Dcoherence.role=storage -Dcoherence.member=storage-${IP_ADDRESS}-${PID} -Dcoherence.log.level=7 ${COH_OPTS}"
    CLASSPATH=""
    JAVA_OPTS="-server -Xmx256m -Xms256m ${JAVA_OPTS}"
    JMX_OPTS="-Dcoherence.management=none" 
    MAIN_CLASS="com.tangosol.net.DefaultCacheServer"
    start
}

proxy() {
    COH_OPTS="-Dcoherence.localstorage=false -Dcoherence.role=proxy -Dcoherence.member=proxy-${IP_ADDRESS}-${PID} -Dcoherence.extend.address=${IP_ADDRESS} -Dextend.proxy.enabled.proxy_load-balancer=true -Dcoherence.log.level=7 ${COH_OPTS}"
    CLASSPATH=""
    JAVA_OPTS="-server -Xmx256m -Xms256m ${JAVA_OPTS}"
    JMX_OPTS="-Dcoherence.management=none" 
    MAIN_CLASS="com.tangosol.net.DefaultCacheServer"
    start
}

console() {
    COH_OPTS="-Dcoherence.localstorage=false -Dcoherence.role=console ${COH_OPTS}"
    CLASSPATH=""
    JMX_OPTS="-Dcoherence.management=none" 
    MAIN_CLASS="com.tangosol.net.CacheFactory"
    start
}

queryPlus() {
    COH_OPTS="-Dcoherence.localstorage=false -Dcoherence.role=query ${COH_OPTS}"
    CLASSPATH=""
    JMX_OPTS="-Dcoherence.management=none" 
    MAIN_CLASS="com.tangosol.coherence.dslquery.QueryPlus"	
    start
}


mbean() {
    COH_OPTS="-Dcoherence.localstorage=false -Dcoherence.role=mbean -Dcoherence.member=mbean-${IP_ADDRESS}-${PID} -Dcoherence.management.remote.host=${IP_ADDRESS} -Dtangosol.coherence.management.report.configuration=coherence-report.xml -Dcoherence.reporter.output.directory=${COHERENCE_DOMAIN}/reports -Dtangosol.coherence.management.report.autostart=true ${COH_OPTS}"
    CLASSPATH=""
    JAVA_OPTS="-server -Xmx128m -Xms128m ${JAVA_OPTS}"
    JMX_OPTS="-Dcoherence.management=all -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false ${JMX_OPTS}"
    MAIN_CLASS="com.tangosol.net.management.MBeanConnector -rmi"
    start
}

start() {

    # Common Coherence options
    COH_OPTS="-Dcoherence.cacheconfig=cache-config-server.xml -Dcoherence.pof.config=pof-config-server.xml -Dcoherence.log=log4j -Did=${PPID} -Dlogdir=${COHERENCE_DOMAIN}/log -Dcoherence.machine=${MACHINE_NAME} ${COH_OPTS}"

    if [ "${COH_WKA}" != "" ]
    then
       COH_OPTS="${COH_OPTS} -Dcoherence.wka=${COH_WKA}"
    fi

    if [ "${COH_EXTEND_PORT}" != "" ]
    then
       COH_OPTS="${COH_OPTS} -Dcoherence.extend.port=${COH_EXTEND_PORT}"
    fi

    CLASSPATH="${COHERENCE_DOMAIN}/config:${COHERENCE_DOMAIN}/libCache/*:${COHERENCE_DOMAIN}/lib/*:${COHERENCE_DOMAIN}/log:/conf:/lib/*:${CLASSPATH}:${COHERENCE_HOME}/conf:${COHERENCE_HOME}/lib/*"

    CMD="${JAVA_HOME}/bin/java -cp ${CLASSPATH} ${JAVA_OPTS} ${GC_OPTS} ${COH_OPTS} ${JMX_OPTS} ${MAIN_CLASS} ${COH_MAIN_ARGS}"

    echo "Starting Coherence ${COMMAND} using ${CMD}"

    exec ${CMD}
}

main "$@"
