#!/bin/bash
read -p "Instance domain: " domain
read -s -p "Instance password: " pass
echo "Creating instance ..."
docker exec -ti cozy cozy-stack instances add --passphrase $pass --apps home,drive,photos,settings $domain
