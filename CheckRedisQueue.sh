
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