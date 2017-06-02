WIP - WIP - WIP - WIP - WIP - WIP - WIP - WIP - WIP - WIP - WIP - WIP

Sample Dockerfile to build an image embedding a Gozy server.

## Usage

 - build image: `docker build -t gozy .`
 - start a container: `docker run --rm -it -p 127.0.0.1:8080:8080 -p 127.0.0.1:5984:5984 --name "gozy" gozy`
 - start a shell inside a running container: `docker exec -ti gozy /bin/bash`
