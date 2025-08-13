#!/bin/sh
#
# Environment variables used:
#  - SERVER: hostname or IP-address of the NFS-server
#  - EXPORT: NFS-export to test (should start with "/")

echo "Client Script"

# enable some more output
set -x

[ -n "${SERVER}" ]
[ -n "${EXPORT}" ]
[ -n "${TEST_PARAMETERS}" ]

# install build and runtime dependencies
dnf -y install git gcc nfs-utils redhat-rpm-config krb5-devel python3-devel python3-gssapi python3-ply

dnf -y install wget git gcc gcc-c++ time make automake autoconf pkgconf pkgconf-pkg-config libtool bison flex perl perl-Time-HiRes python3 wget tar libaio-devel net-tools nfs-utils

cd /root;git clone https://github.com/pjd/pjdfstest.git;cd pjdfstest;autoreconf -ifs;./configure;make pjdfstest

mkdir -p /mnt/nfsv3
mount -t nfs -o vers=3 ${SERVER}:${EXPORT} /mnt/nfsv3
cd /opt/ltp; sudo ./runltp -d /mnt/nfsv3  -f fs -o /tmp/ltp_output_v3.log -l /tmp/ltp_run_v3.log -p


mkdir -p /mnt/nfsv4
mount -t nfs -o vers=4 ${SERVER}:${EXPORT} /mnt/nfsv4
cd /opt/ltp; sudo ./runltp -d /mnt/nfsv4  -f fs -o /tmp/ltp_output_v4.log -l /tmp/ltp_run_v4.log -p


# v4.1 mount
mkdir -p /mnt/nfsv41
mount -t nfs -o vers=4.1 ${SERVER}:${EXPORT} /mnt/nfsv41
cd /opt/ltp; sudo ./runltp -d /mnt/nfsv41  -f fs -o /tmp/ltp_output_v41.log -l /tmp/ltp_run_v41.log -p
