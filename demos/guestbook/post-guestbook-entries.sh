#!/bin/bash


svcip=$(kubectl -n guestbook get svc frontend -o json | jq -r .status.loadBalancer.ingress[0].ip)
echo "Starting to post to ${svcip}"


for i in $(seq 0 5); do
  message="Hello ${i} world!"
  for j in $(seq 1 10); do
	echo "===${i},${j}==="
	message="${message},this is ${i}-${j}"
	curl 'http://'${svcip}'/guestbook.php?cmd=set&key=messages' --data-urlencode "value=${message}" -G
	sleep 3s
	curl 'http://'${svcip}'/guestbook.php?cmd=get&key=messages'
	sleep 3s
  done
done

echo "Done."
