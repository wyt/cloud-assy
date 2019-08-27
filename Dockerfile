FROM openjdk:8u212-jdk

MAINTAINER wangyongtao

ENV APP_LOG_PATH="/applog" \
    FILE_BEAT_CRT_PATH="/etc/pki/tls/certs" \
    FILE_BEAT_PACKAGE_NAME="filebeat" \
    SKYWALKING_AGENT_PACKAGE_NAME="skywalking-agent" \
    FILE_BEAT_CRT_NAME="logstash-beats.crt" \
    ENTRYPOINT_FILE_NAME="cloud-assy-entrypoint.sh" \
    WAIT_FOR_IT="wait-for-it.sh" \
    TZ="Asia/Shanghai"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && . /etc/profile \
    && mkdir $APP_LOG_PATH \
    && mkdir -p $FILE_BEAT_CRT_PATH

COPY ./$FILE_BEAT_CRT_NAME $FILE_BEAT_CRT_PATH/
COPY ./$FILE_BEAT_PACKAGE_NAME /opt/$FILE_BEAT_PACKAGE_NAME
COPY ./$ENTRYPOINT_FILE_NAME /$ENTRYPOINT_FILE_NAME
COPY ./$WAIT_FOR_IT /$WAIT_FOR_IT
COPY ./$SKYWALKING_AGENT_PACKAGE_NAME /opt/$SKYWALKING_AGENT_PACKAGE_NAME

RUN chmod -R 755 /opt/$FILE_BEAT_PACKAGE_NAME \
    && chmod a+x /$ENTRYPOINT_FILE_NAME \
    && chmod a+x /$WAIT_FOR_IT