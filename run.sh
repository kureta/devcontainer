#!/bin/env bash

run() {
	# Check to see if a container named archdev exists
	if [ -n "$(docker ps -q -f name=archdev)" ]; then
		echo "Container exists"
		# if it is runnong, attach to it
		if [ -n "$(docker ps -aq -f status=running -f name=archdev)" ]; then
			echo "Container is running. Attaching to it..."
			docker attach archdev
		else
			echo "Container is not running. Starting it..."
			# if it is not running, start it
			docker start archdev && docker attach archdev
		fi
	else
		echo "Container does not exists. Creating and attaching to it..."
		# if it does not exist, create it and attach to it
		docker run -it --name archdev kureta/archdev:latest
	fi
}

build() {
	docker rm archdev
	docker build --ssh default=$SSH_AUTH_SOCK -t kureta/archdev:latest .
}

$*
