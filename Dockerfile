FROM debian:stretch

RUN apt-get update && apt-get --no-install-recommends -y install \
            ca-certificates \
            curl \
            net-tools \
            nginx \
            sudo \
            vim-tiny \
            build-essential \
            pkg-config \
            erlang \
            libicu-dev \
            libmozjs185-dev \
            libcurl4-openssl-dev

# Install CouchDB
RUN cd /tmp && \
    curl -LO https://dist.apache.org/repos/dist/release/couchdb/source/2.3.1/apache-couchdb-2.3.1.tar.gz && \
    tar xf apache-couchdb-2.3.1.tar.gz && \
    cd apache-couchdb-2.3.1 && \
    ./configure && \
    make release && \
    adduser --system \
            --no-create-home \
            --shell /bin/bash \
            --group --gecos \
            "CouchDB Administrator" couchdb && \
    cp -R rel/couchdb /home/couchdb && \
    chown -R couchdb:couchdb /home/couchdb && \
    find /home/couchdb -type d -exec chmod 0770 {} \; && \
    chmod 0644 /home/couchdb/etc/* && \
    mkdir /var/log/couchdb && chown couchdb: /var/log/couchdb

# Run CouchDB
RUN sudo -b -i -u couchdb sh -c '/home/couchdb/bin/couchdb >> /var/log/couchdb/couch.log 2>> /var/log/couchdb/couch-err.log' && \
    sleep 30 && \
    curl -X PUT http://127.0.0.1:5984/_users && \
    curl -X PUT http://127.0.0.1:5984/_replicator && \
    curl -X PUT http://127.0.0.1:5984/_global_changes

# Cozy-stack
RUN curl -o /usr/local/bin/cozy-stack -L https://github.com/cozy/cozy-stack/releases/download/2018M3S6/cozy-stack-linux-amd64 && \
    chmod +x /usr/local/bin/cozy-stack && \
    adduser --system \
            --shell /bin/bash \
            --group --gecos \
            "Cozy" cozy && \
    # @FIXME we should remove this hack and use `--fs-url file://localhost/var/lib/cozy` once its available
    mkdir /usr/local/bin/storage && \
    chown cozy: /usr/local/bin/storage && \
    mkdir /var/log/cozy && \
    chown cozy: /var/log/cozy && \
    mkdir /var/lib/cozy && \
    chown -R cozy: /var/lib/cozy && \
    mkdir /etc/cozy && \
    curl -o /etc/cozy/cozy.yaml https://raw.githubusercontent.com/cozy/cozy-stack/master/cozy.example.yaml && \
    sed -i 's#/path/to/key#/etc/cozy/credentials-key#g' /etc/cozy/cozy.yaml
    
RUN chown -R cozy: /etc/cozy

COPY ./start.sh /
COPY ./nginx-config /etc/cozy/

RUN chmod +x /start.sh

EXPOSE 8080 6060 5984 1443

ENTRYPOINT ["/start.sh"]
