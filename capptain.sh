#!/bin/sh

port=8080
if [ "$1" != "" ]; then
	port="$1"
fi

exec carbon -port "$port" -root ./apps capptain.lua /
