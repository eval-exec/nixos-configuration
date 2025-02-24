#!/bin/sh

logger -t network_dispatcher $(printf "network dispathcer: [%s], [%s]\n" $1 $2)

# systemctl --user restart clash
systemctl --user restart matrix
systemctl --user restart matrix_port_forward
