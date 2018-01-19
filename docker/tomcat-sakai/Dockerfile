FROM cloudesire/java:8


MAINTAINER GuillaumeHaben <guillaume.haben@telecomnancy.net>


RUN apt-get update
RUN apt-get install -yq --no-install-recommends wget pwgen ca-certificates
RUN apt-get install -yq --no-install-recommends libtcnative-1
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.0.32
ENV CATALINA_HOME=/tomcat
ENV JAVA_OPTS='-server -Xms512m -Xmx1024m -XX:PermSize=128m \
			-XX:NewSize=192m -XX:MaxNewSize=384m -Djava.awt.headless=true \
			-Dhttp.agent=Sakai -Dorg.apache.jasper.compiler.Parser.STRICT_QUOTE_ESCAPING=false \
			-Dsun.lang.ClassLoader.allowArraySyntax=true -Djava.util.Arrays.useLegacyMergeSort=true \
			-Dsakai.demo=true'
ENV TOMCAT_BIND_ON_INIT true


# INSTALL TOMCAT

RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat && \
    rm -fr tomcat/webapps/examples && \
    rm -fr tomcat/webapps/docs && \
    sed -i "s/Connector port=\"8080\"/Connector port=\"8080\" bindOnInit=\"${TOMCAT_BIND_ON_INIT}\"/" tomcat/conf/server.xml

ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh


# CONFIGURE TOMCAT FOR SAKAI

COPY ./context.xml $CATALINA_HOME/conf/context.xml
COPY ./server.xml $CATALINA_HOME/conf/server.xml
COPY ./catalina.properties $CATALINA_HOME/conf/catalina.properties
RUN mkdir $CATALINA_HOME/sakai
COPY ./sakai.properties $CATALINA_HOME/sakai/sakai.properties

WORKDIR /tmp
RUN wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.36.tar.gz
RUN tar -zxvf mysql-connector-java-5.1.36.tar.gz
RUN mv mysql-connector-java-5.1.36/mysql-connector-java-5.1.36-bin.jar $CATALINA_HOME/lib/mysql-connector-java-5.1.36-bin.jar



EXPOSE 8080
CMD ["/run.sh"]