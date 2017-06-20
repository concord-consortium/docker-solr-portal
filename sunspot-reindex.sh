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
LOG_FILE=/tmp/sunspot.reindex.log

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
# call Portal's sunspot reindex API. Retry until successful, then exit.
#
reindex() {

    while [ 1 ]; do

        log "Attempting to ping solr server ..."

        curl --fail "${SOLR_PING_URL}" >> ${LOG_FILE} 2>&1

        if [ $? != 0 ]; then
            log "Sleeping ${SLEEP_TIME} seconds to wait for solr server ..."
            sleep ${SLEEP_TIME}
            continue
        fi

        log "Attempting to re-indexing sunspot ..."

        curl -G -v "${SERVICE_API_ENDPOINT}" --data-urlencode "service_api_key=${SERVICE_API_KEY}" >> ${LOG_FILE} 2>&1

        if [ $? == 0 ]; then
            log "Sunspot re-index completed."
            exit 0
        fi

        log "Sleeping ${SLEEP_TIME} seconds waiting to retry re-indexing sunspot ..."
        sleep ${SLEEP_TIME}
    done
}

log "Starting sunspot automatic re-index ..."

reindex &

