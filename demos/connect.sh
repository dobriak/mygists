#!/bin/bash
log=/var/log/connect.log
pid=connect.pid
source boxes
server_type=${1}
boxes=""

case "$1" in
	web)
		boxes="${app}:2000 ${db}:3306"
		;;
	app)
                boxes="${web}:8080 ${db}:3306"
		;;
	db)
		boxes="${app}:2000 ${web}:8080"
		;;
	cweb)
		boxes="${app}:2000"
		;;
	capp)
                boxes="${db}:3306"
		;;
	kill)
		if [ -f connect.pid ]; then
			pid=$(cat connect.pid)
			echo "Killing process ${pid}"
			kill $pid
			exit $?
		else
			echo "connect.pid not found"
			exit 1
		fi
		;;
	*)
		echo "Usage: ${0} <[c]web|[c]app|db|kill>"
		exit 1
		;;
esac

if [ ! -f $log ]; then
	sudo touch $log
	sudo chown $USER:$USER $log
fi

echo "Connecting to ${boxes} in an endless loop. To stop it: ${0} kill"
#echo 'kill $(cat connect.pid)'
(while true; do
	for h in $boxes ; do
		curl -m 3 ${h}
		sleep 3s
	done
done) &> $log &
echo $! > $pid

echo "Done."
