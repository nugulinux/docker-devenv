#!/bin/sh

mkdir -p /var/run/dbus
rm -f /var/run/dbus/pid
dbus-daemon --system &

exec "$@"
