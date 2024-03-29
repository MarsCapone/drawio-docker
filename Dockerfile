FROM tomcat:9-jre8-alpine

LABEL maintainer="Florian JUDITH <florian.judith.b@gmail.com>"

ARG VERSION=12.0.0
#ARG VERSION=v11.0.5

RUN apk add openjdk8 apache-ant git patch xmlstarlet certbot curl

RUN cd /tmp && \
    curl -OL https://github.com/MarsCapone/drawio/archive/${VERSION}.zip && \
    unzip ${VERSION}.zip && \
    cd /tmp/drawio-${VERSION} && \
    cd /tmp/drawio-${VERSION}/etc/build && \
    ant war && \
    cd /tmp/drawio-${VERSION}/build && \
    mkdir -p $CATALINA_HOME/webapps/draw && \
    unzip /tmp/drawio-${VERSION}/build/draw.war -d $CATALINA_HOME/webapps/draw && \
    rm -rf \
        /tmp/${VERSION}.zip \
        /tmp/drawio-${VERSION}

# Update server.xml to set Draw.io webapp to root
RUN cd $CATALINA_HOME && \
    xmlstarlet ed \
    -P -S -L \
    -i '/Server/Service/Engine/Host/Valve' -t 'elem' -n 'Context' \
    -i '/Server/Service/Engine/Host/Context' -t 'attr' -n 'path' -v '/' \
    -i '/Server/Service/Engine/Host/Context[@path="/"]' -t 'attr' -n 'docBase' -v 'draw' \
    -s '/Server/Service/Engine/Host/Context[@path="/"]' -t 'elem' -n 'WatchedResource' -v 'WEB-INF/web.xml' \
    -i '/Server/Service/Engine/Host/Valve' -t 'elem' -n 'Context' \
    -i '/Server/Service/Engine/Host/Context[not(@path="/")]' -t 'attr' -n 'path' -v '/ROOT' \
    -s '/Server/Service/Engine/Host/Context[@path="/ROOT"]' -t 'attr' -n 'docBase' -v 'ROOT' \
    -s '/Server/Service/Engine/Host/Context[@path="/ROOT"]' -t 'elem' -n 'WatchedResource' -v 'WEB-INF/web.xml' \
    conf/server.xml

# Copy custom custom interception file.
COPY modals.js $CATALINA_HOME/webapps/draw/js/interception/modals.js
COPY main.js $CATALINA_HOME/webapps/draw/js/interception/main.js

# Copy docker-entrypoint
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

WORKDIR $CATALINA_HOME

EXPOSE 8080 8443

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]
