# docker-builder
# ------------------------------------------------------------------------------------------------

# build
# docker build -t ebuit/docker-builder --build-arg JSON_FILE=master-scheduler.json .

# run 
# docker run -it -t -v  -v /var/run/docker.sock:/var/run/docker.sock ebuit/docker-builder


FROM alpine:latest

MAINTAINER Metairie Stephane EBU:0.1

ARG JSON_FILE

RUN apk update && apk add git maven openjdk8 docker
RUN wget -q https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O /usr/bin/jq && chmod 755 /usr/bin/jq

# placeholder
RUN mkdir /opt
WORKDIR /opt

# copy main script
RUN mkdir docker-builder
COPY docker-builder.sh /opt/docker-builder/docker-builder.sh
RUN chmod +x /opt/docker-builder/docker-builder.sh

# copy configuration
ADD ${JSON_FILE} /opt/docker-builder/docker-builder.json

# start main command
CMD /opt/docker-builder/docker-builder.sh /opt/docker-builder/docker-builder.json