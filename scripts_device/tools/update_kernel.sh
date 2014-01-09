#!/bin/bash -e
#
# Copyright (c) 2013 Robert Nelson <robertcnelson@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

if ! id | grep -q root; then
	echo "must be run as root"
	exit
fi

machine=$(cat /proc/device-tree/model | sed "s/ /_/g")
case "${machine}" in
TI_AM335x_BeagleBone)
        SOC="omap-psp"
        ;;
*)
        echo "Machine: [${machine}]"
        unset SOC
        ;;
esac

dist=$(lsb_release -cs)
arch=$(dpkg --print-architecture)

if [ ! "x${SOC}" = "x" ] ; then
        cd /tmp/
        if [ -f /tmp/LATEST-${SOC} ] ; then
                rm -f /tmp/LATEST-${SOC} || true
        fi
        if [ -f /tmp/install-me.sh ] ; then
                rm -f /tmp/install-me.sh || true
        fi

        wget http://rcn-ee.net/deb/${dist}-${arch}/LATEST-${SOC}
        if [ -f /tmp/LATEST-${SOC} ] ; then
                wget $(cat /tmp/LATEST-${SOC} | grep STABLE | awk '{print $3}')
                /bin/bash /tmp/install-me.sh
        fi
fi