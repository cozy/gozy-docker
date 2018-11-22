#!/bin/bash
docker build -t cozy .
docker run --rm -it -p 8080:8080 -p 5984:5984 -p 1443:1443 --name "cozy" cozy