# Docker Solr Portal

This is a small extension to the official solr:5.3 Docker container for use with the portal under Docker.  At startup it creates the development, test and production cores if they do not exist using the solr config copied from the portal (Rigse) repo.  The reason this exists is that Rancher currently does not support version 2 of docker-compose so there is no way to mount the portal container as a volume within the default solr container in order to access the portal Solr config.

This container also contains a script to start the Solr data volume.  The script first chowns the cores parent directory to solr:solr from root so that the solr user can create the cores at startup and then enters a blocking read loop to keep the container alive.
