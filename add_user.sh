#!/bin/bash
echo "Creating instance ..."
docker exec -ti cozy cozy-stack instances add --passphrase $2 --apps home,drive,photos,settings $1
