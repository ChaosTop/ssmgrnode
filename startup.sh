#!/bin/sh

# turn on bash's job control
set -m

# Start the primary process and put it in the background
ss-manager -m chacha20 -u -d 1.1.1.1 --plugin obfs-server --plugin-opts "obfs=tls" --manager-address 127.0.0.1:4001 &

# Start the helper process
ssmgr -c default.yml -m 0.0.0.0:4002

# the my_helper_process might need to know how to wait on the
# primary process to start before it does its work and returns


# now we bring the primary process back into the foreground
# and leave it there
fg %1
