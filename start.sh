#!/bin/bash
echo "⋅ Starting CouchDB…"
sudo -b -i -u couchdb sh -c '/home/couchdb/bin/couchdb >> /var/log/couchdb/couch.log 2>> /var/log/couchdb/couch-err.log'
sleep 10
read -sp "Server Passphrase: " pass
export COZY_ADMIN_PASSWORD=$pass
echo -e "$COZY_ADMIN_PASSWORD\n$COZY_ADMIN_PASSWORD" | /usr/local/bin/cozy-stack config passwd /etc/cozy/ > /dev/null
#for pid in $(pgrep cozy-stack); do kill -15 $pid;done
echo "Starting Cozy stack…"
sudo -b -u cozy sh -c '/usr/local/bin/cozy-stack serve --log-level debug --host 0.0.0.0 >> /var/log/cozy/cozy.log 2 >> /var/log/cozy/cozy-err.log'
#cozy-stack instances destroy "cozy.tools:8080" 2>/dev/null
sleep 10
echo "⋅ Creating instance…"
read -p "Public port : " -i 1443 -e public_port
read -p "Instance domain : " -i "cozy.tools" -e instance_domain
read -p "Server port : " -i 8080 -e server_port
read -sp "Instance passphrase: " server_pass
echo "Creating instance"
cozy-stack instances add --host 0.0.0.0 --apps drive,photos,collect,settings,onboarding --passphrase "$server_pass" "${instance_domain}:${public_port}"
echo "⋅ Creating certificate…"
openssl req -x509 -nodes -newkey rsa:4096 -keyout "/etc/cozy/${instance_domain}.key" -out "/etc/cozy/${instance_domain}.crt" -days 365 -subj "/CN=\*.${instance_domain}"
echo "⋅ Configuring NGinx…"
sed "s/%PORT%/$public_port/g; s/%DOMAIN%/$instance_domain/g; s/%SERVER_PORT%/$server_port/g" /etc/cozy/nginx-config > "/etc/nginx/sites-available/${instance_domain}.conf"
ln -s "/etc/nginx/sites-available/${instance_domain}.conf" /etc/nginx/sites-enabled/
echo "⋅ Starting NGinx…"
service nginx start

echo "Running"
read
