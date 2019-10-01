FROM openjdk:8  

ARG VERSION

RUN mkdir -p /opt/flume
RUN mkdir -p /opt/prometheus/lib

ADD ./flume-ng-dist/target/apache-flume-$VERSION-bin.tar.gz /opt/flume/
RUN ln -s /opt/flume/apache-flume-$VERSION-bin /opt/flume/apache-flume
 
COPY ./jmx_prometheus_javaagent.jar /opt/prometheus/lib/
COPY ./star_ge_vimeows_com.keystore /opt/flume/

ENTRYPOINT ["/opt/flume/apache-flume/bin/flume-ng"]

EXPOSE 1468/tcp
EXPOSE 5445/tcp
