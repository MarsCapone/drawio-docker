#!/usr/bin/env bash

PORT=8080
DOCKERJS=/usr/local/tomcat/webapps/draw/js

docker run --rm --name="draw" -p ${PORT}:8080 -p 8443:8443 \
  -v $(readlink -f main.js):${DOCKERJS}/interception/main.js \
  -v $(readlink -f modals.js):${DOCKERJS}/interception/modals.js \
  -it casperc/drawio
