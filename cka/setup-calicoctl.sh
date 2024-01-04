#!/bin/bash
# setting calico version
CALICO_VERSION="v3.27.0"

# run this script with sudo

if ! [ $USER = root ]
then
	echo run this script with sudo
	exit 3
fi

# beta: building in ARM support
[ $(arch) = aarch64 ] && PLATFORM=arm64
[ $(arch) = x86_64 ] && PLATFORM=amd64

cd /usr/local/bin/
curl -L "https://github.com/projectcalico/calico/releases/download/${CALICO_VERSION}/calicoctl-linux-${PLATFORM}" -o calicoctl
chmod +x calicoctl
