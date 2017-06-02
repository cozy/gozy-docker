#!/bin/bash
echo "Starting CouchDB…"
sudo -b -i -u couchdb sh -c '/home/couchdb/bin/couchdb >> /var/log/couchdb/couch.log 2>> /var/log/couchdb/couch-err.log'
sleep 10
read -sp "Server Passphrase: " pass
export COZY_ADMIN_PASSWORD=$pass
echo -e "$COZY_ADMIN_PASSWORD\n$COZY_ADMIN_PASSWORD" | /usr/local/bin/cozy-stack config passwd /etc/cozy/ > /dev/null
#for pid in $(pgrep cozy-stack); do kill -15 $pid;done
echo "Starting Cozy stack…"
sudo -b -u cozy sh -c '/usr/local/bin/cozy-stack serve --log-level debug >> /var/log/cozy/cozy.log 2 >> /var/log/cozy/cozy-err.log'
#cozy-stack instances destroy "cozy.tools:8080" 2>/dev/null
sleep 10
echo "Creating instance…"
read -p "Instance URL: " server_url
read -sp "Instance passphrase: " server_pass
echo "Creating instance"
cozy-stack instances add --host 0.0.0.0 --apps files,settings,onboarding --passphrase "$server_pass" "$server_url"

echo "Running"
read
