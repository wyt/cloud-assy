#! /bin/bash
# cat -A cloud-assy-entrypoint.sh
# dos2unix cloud-assy-entrypoint.sh
echo "executing bash."

echo "$1"
echo "$2"
echo "$FILEBEAT_OP_LS_HOSTS"

if [ -e .host_env ]; then
  # 打印.host_env文件内容
  echo ".host_env file content:"
  cat .host_env

  # 将.host_env文件内容设置为环境变量
  for line in `cat .host_env`; do echo "export $line" >> /etc/profile ;done
  source /etc/profile
else
  echo ".host_env does not exist."
fi

echo "env info:"
env

if [[ $2 == *"uat"* ]] || [[ $2 == *"prod"* ]]
then
  echo "start filebeat now ..."
  nohup /opt/filebeat/filebeat -E "output.logstash.hosts=['$FILEBEAT_OP_LS_HOSTS']" -e -c /opt/filebeat/filebeat.yml >/dev/null 2>&1 &
fi

echo "start springboot jar now ..."

case ${SKYWALKING_ANGENT_ENABLE} in
"true")
  VAR_MIDDLE=${1%%.*}
  SKYWALKING_AGENT_SERVICE_NAME=${VAR_MIDDLE:1}
  echo "skywalking.agent.service_name: ${SKYWALKING_AGENT_SERVICE_NAME}"
  java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap \
   -javaagent:/opt/skywalking-agent/skywalking-agent.jar \
   -Dskywalking.agent.service_name=${SKYWALKING_AGENT_SERVICE_NAME} \
   -Dskywalking.collector.backend_service=${SKYWALKING_COLLECTOR_BACKEND_SERVICE} \
   -Djava.security.egd=file:/dev/./urandom -jar $1 $2
  ;;
*)
  java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap \
   -Djava.security.egd=file:/dev/./urandom -jar $1 $2
  ;;
esac