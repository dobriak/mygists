#!/bin/bash
# Start a python web server on a specific port and put it in the background.
# Save the process ID of said server so you can kill it later
# Usage: ./serve.sh <web|app|db>
# Generated output: current.log and current.pid

server_type=${1}
port=0

case "$1" in
	web)
		port=8080
		;;
	app)
		port=2000
		;;
	db)
		port=3306
		;;
	kill)
		if [ -f current.pid ]; then
			pid=$(cat current.pid)
			echo "Stopping process ${pid}"
			kill $pid
			exit $?
		else
			echo "current.pid not found."
			exit 1
		fi
		;;
	*)
		echo "Usage: ${0} <web|app|db|kill>"
		exit 1
		;;
esac

# Create a directory and stick an index.html file in it for serving
if [ ! -d ${server_type} ]; then
	mkdir ${server_type}
	echo "$(hostname -f): Hello from ${server_type} on port ${port}" > ${server_type}/index.html
fi

echo "Listening on port '${port}' in the background. To stop it: ${0} kill"
#echo 'kill $(cat current.pid)'
nohup python3 -u -m http.server -d ${server_type} ${port} &> current.log &
echo $! > current.pid

echo "Done."
