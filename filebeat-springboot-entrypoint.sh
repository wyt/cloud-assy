#! /bin/bash
# cat -A filebeat-springboot-entrypoint.sh
# dos2unix filebeat-springboot-entrypoint.sh
echo "executing bash."

echo "$1"
echo "$2"
echo "$FILEBEAT_OP_LS_HOSTS"

# 打印.host_env文件内容
echo ".host_env file content:"
cat .host_env

# 将.host_env文件内容设置为环境变量
for line in `cat .host_env`; do echo "export $line" >> /etc/profile ;done
source /etc/profile
echo "env info:"
env

if [[ $2 == *"uat"* ]] || [[ $2 == *"prod"* ]]
then
  echo "start filebeat now ..."
  nohup /opt/filebeat-6.2.2-linux-x86_64/filebeat -E "output.logstash.hosts=['$FILEBEAT_OP_LS_HOSTS']" -e -c /opt/filebeat-6.2.2-linux-x86_64/filebeat.yml >/dev/null 2>&1 &
fi

echo "start springboot jar now ..."

#java -Djava.security.egd=file:/dev/./urandom -jar $1 $2

VAR_MIDDLE=${1%%.*}
SKYWALKING_AGENT_SERVICE_NAME=${VAR_MIDDLE:1}

echo "skywalking.agent.service_name: ${SKYWALKING_AGENT_SERVICE_NAME}"

java -javaagent:/opt/skywalking-agent/skywalking-agent.jar -Dskywalking.agent.service_name=${SKYWALKING_AGENT_SERVICE_NAME} -Dskywalking.collector.backend_service=${SKYWALKING_COLLECTOR_BACKEND_SERVICE} -Djava.security.egd=file:/dev/./urandom -jar $1 $2