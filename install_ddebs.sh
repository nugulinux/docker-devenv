#!/bin/sh

apt-get update
apt-get install -y ubuntu-dbgsym-keyring

echo "deb [trusted=yes] http://ddebs.ubuntu.com $(lsb_release -cs) main restricted universe multiverse" > /etc/apt/sources.list.d/ddebs.list
echo "deb [trusted=yes] http://ddebs.ubuntu.com $(lsb_release -cs)-updates main restricted universe multiverse" >> /etc/apt/sources.list.d/ddebs.list
echo "deb [trusted=yes] http://ddebs.ubuntu.com $(lsb_release -cs)-proposed main restricted universe multiverse" >> /etc/apt/sources.list.d/ddebs.list

cat /etc/apt/sources.list.d/ddebs.list

apt-get update
apt-get install -y \
	libasound2-dbgsym \
	libcurl4-dbgsym \
	libgstreamer1.0-0-dbg \
	libopus-dbg libopus0-dbgsym \
	libpulse0-dbgsym

