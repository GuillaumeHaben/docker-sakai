#!/bin/bash
SOURCES="/home/guillaume/Documents/sakai"
DOCKER="/home/guillaume/Documents/sakai-docker"
TARGET="/home/guillaume/Documents/sakai-target"

# Parameters
if (( $# > 1 )); then
	echo "Usage: $0 (build)"
	exit
else
	BUILD="$1"
fi

# If build option, then build from source
if [ "$BUILD" == "build" ]; then
	cd ${SOURCES}
	/opt/apache-maven-3.5.2/bin/mvn install sakai:deploy -Dmaven.tomcat.home=${TARGET} -Djava.net.preferIPv4Stack=true -Dmaven.test.skip=true
fi

# Set up docker containers
cd ${DOCKER}
docker-compose up -d

# Copy the built webapps into containers
cd ${TARGET}
docker cp webapps/. docker-tomcat-sakai:/tomcat/webapps
docker cp lib/. docker-tomcat-sakai:/tomcat/lib
docker cp components/. docker-tomcat-sakai:/tomcat/components

docker stop docker-tomcat-sakai
docker start docker-tomcat-sakai