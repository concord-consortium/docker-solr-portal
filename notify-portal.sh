#!/bin/bash
set +e

#
# Time to wait between making server requests in case of
# failure / retry.
#
SLEEP_TIME=10

#
# Log file.
#
LOG_FILE=/tmp/notify.portal.log

#
# Log messages to stdout and log file.
#
log() {

    echo "[`date`]" $*

    echo ""             >> ${LOG_FILE}
    echo "[`date`]" $*  >> ${LOG_FILE}
    echo ""             >> ${LOG_FILE}
}

#
# Determine if solr server is up and if so then attempt to
# call Portal's solr initialized API. Retry until successful, then exit.
#
notify_portal() {

    # set the return value of the pipe to be the exit code of the first non zero value
    # this way the tee commands below don't get in the way of curl's exit value
    set -o pipefail

    while [ 1 ]; do

        log "Attempting to ping solr server ..."

        curl --fail --silent --show-error -w "\n" "${SOLR_PING_URL}" 2>&1 | tee -a ${LOG_FILE}

        if [ $? != 0 ]; then
            log "Sleeping ${SLEEP_TIME} seconds to wait for solr server ..."
            sleep ${SLEEP_TIME}
            continue
        fi

        log "Attempting to notify the Portal ..."

        curl --fail --silent --show-error -w "\n" "${SERVICE_API_ENDPOINT}" 2>&1 | tee -a ${LOG_FILE}

        # The endpoint should always return a 200 success message, however if the
        # portal isn't running yet then the load balancer or proxy should return a
        # bad gateway response. The --fail option above turns that into a non 0 exit code
        if [ $? == 0 ]; then
            log "Portal notfied"
            exit 0
        fi

        log "Sleeping ${SLEEP_TIME} seconds before notifing the Portal again ..."
        sleep ${SLEEP_TIME}
    done
}


if [ ! -z "${SERVICE_API_ENDPOINT}" ]; then
    log "Starting Portal notification ..."
    notify_portal &
else
    log "Portal notification not configured."
fi
