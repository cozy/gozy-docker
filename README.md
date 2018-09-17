WIP - WIP - WIP - WIP - WIP - WIP - WIP - WIP - WIP - WIP - WIP - WIP

Sample Dockerfile to build an image embedding a Gozy server.

## Usage

 - build image: `docker build -t gozy .`
 - start a container: `docker run --rm -it -p 127.0.0.1:8080:8080 -p 127.0.0.1:5984:5984 -p 127.0.0.1:1443:1443 --name "gozy" gozy`
 - start a shell inside a running container: `docker exec -ti gozy /bin/bash`

 or

```bash
git clone https://github.com/nicolaspernoud/gozy-docker.git
cd gozy-docker
chmod +x ./build-and-start.sh
./build-and-start.sh
```

Using the default parameters, you should be able to connect to the server on `https://cozy.tools:1443` (the certificate is self signed, so so you should manually allow your browser to connect).