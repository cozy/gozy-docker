#!/bin/bash
echo "⋅ Starting CouchDB…"
sudo -b -i -u couchdb sh -c '/home/couchdb/bin/couchdb >> /var/log/couchdb/couch.log 2>> /var/log/couchdb/couch-err.log'
sleep 10
echo "Starting Cozy stack…"
sudo -b -u cozy sh -c '/usr/local/bin/cozy-stack serve --log-level info --host 0.0.0.0 >> /var/log/cozy/cozy.log 2 >> /var/log/cozy/cozy-err.log'
sleep 10
echo "⋅ Creating instance…"
export public_port="8080"
export instance_domain="demo.cozy.tools"
export COZY_ADMIN_PASSWORD="pass"
echo "Creating instance"
cozy-stack instances add --dev --host 0.0.0.0 --apps settings,onboarding --passphrase "cozy" "${instance_domain}:${public_port}"
cozy-stack apps install --domain "${instance_domain}:${public_port}" drive   'git://github.com/Benibur/cozy-drive.git#gh-pages'
cozy-stack apps install --domain "${instance_domain}:${public_port}" photos  'git://github.com/cozy/cozy-photos-v3.git#build'
cozy-stack apps install --domain "${instance_domain}:${public_port}" collect 'git://github.com/cozy/cozy-collect.git#build'
cozy-stack apps install --domain "${instance_domain}:${public_port}" edf     'git://gitlab.cozycloud.cc/labs/cozy-edf.git#build'
cozy-stack apps install --domain "${instance_domain}:${public_port}" maif    'git://gitlab.cozycloud.cc/labs/cozy-maif.git#build'
cozy-stack apps install --domain "${instance_domain}:${public_port}" bank    'git://gitlab.cozycloud.cc/labs/cozy-bank.git#build'
cozy-stack apps install --domain "${instance_domain}:${public_port}" sante   'git://gitlab.cozycloud.cc/labs/cozy-sante.git#build'

sleep 10
