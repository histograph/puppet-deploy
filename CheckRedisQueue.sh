


while ! redis-cli -h localhost -p 9775 KEYS * > /dev/null 2>&1
do
  echo "SERVER NOT STARTED YET"
  sleep 300s;
done

while [ "$(redis-cli -h localhost -p 9775 LLEN histograph)" == "0" ]
do
  echo "QUEUE NOT POPULATED YET"
  sleep 300s;
done

while [ "$(redis-cli -h localhost -p 9775 LLEN histograph)" != "0" ]
do
  echo "QUEUE LENGTH = $(redis-cli -h localhost -p 9775 LLEN histograph)"
  sleep 300s;
done

echo "DONE !!!"