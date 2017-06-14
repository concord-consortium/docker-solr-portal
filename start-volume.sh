echo Starting up solr data volume

# this is owned by root but needs to be owned by solr so it can create files
chown solr:solr /opt/solr/server/solr/mycores

# wait forever so the volume container stays up
while :; do read; done
