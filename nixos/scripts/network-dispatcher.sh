#!/bin/sh

printf "network dispathcer:[%s], [%s]" $1 $2

systemctl --user restart ollama_port_forward
systemctl --user restart ra-mutiplex_port_forward
systemctl --user restart clash
