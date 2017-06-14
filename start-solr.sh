cd /opt/solr

CONFIG_SOURCE="/opt/solr/rigse-solr-docker/sunspot"
coresdir="/opt/solr/server/solr/mycores"
mkdir -p $coresdir

create_core () {
  coredir="$coresdir/$1"
  if [ ! -d $coredir ]; then
      cp -r $CONFIG_SOURCE/ $coredir
      chown solr:solr $coredir
      touch "$coredir/core.properties"
      echo created "$1"
  else
      echo "core $1 already exists"
  fi
}

create_core mycore
create_core development
create_core test
create_core production

docker-entrypoint.sh solr-foreground
