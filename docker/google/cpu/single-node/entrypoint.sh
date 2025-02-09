#!/bin/bash

# Note - we might want to change this

echo "====== hostname"
hostname

echo "====== dmidecode"
dmidecode

# Disabling - takes too long to run
# echo "====== 7z b"
# 7z b

# This produces the same output as:
# lstopo -o-f xml > machine.xml
# except the ProcessName lstopo -> hwloc-ls
echo 
echo "====== hwloc-ls machine.xml"
mydir=$(mktemp -d)
hwloc-ls $mydir/machine.xml
cat $mydir/machine.xml

echo
echo "====== lstopo --of svg > machine.svg"
lstopo --of svg > $mydir/machine.svg
cat $mydir/machine.svg

# Single thread, if we do >1 the output gets messed up
echo
echo "====== sysbench cpu run"
sysbench cpu run

echo
echo "====== sysbench fileio run --file-test-mode=seqwr"
cd $mydir
sysbench fileio run --file-test-mode=seqwr

echo
echo "====== sysbench threads run"
sysbench threads run

echo
echo "====== sysbench mutex run"
sysbench mutex run

echo "====== lscpu"
lscpu

echo "====== cat /proc/cpuinfo"
cat /proc/cpuinfo

echo "====== cpuid"
cpuid
cd -
rm -rf $mydir
