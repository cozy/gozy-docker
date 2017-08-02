#!/bin/bash
echo "⋅ Starting CouchDB…"
sudo -b -i -u couchdb sh -c '/home/couchdb/bin/couchdb >> /var/log/couchdb/couch.log 2>> /var/log/couchdb/couch-err.log'
sleep 10
echo "Starting Cozy stack…"
sudo -b -u cozy sh -c '/usr/local/bin/cozy-stack serve --log-level info --host 0.0.0.0 >> /var/log/cozy/cozy.log 2 >> /var/log/cozy/cozy-err.log'
sleep 10

read
