#!/bin/bash

# This script removes PhiX reads using BBDuk.

mkdir -p /data/trim_reads

/bbmap/bbduk.sh threads=$NSLOTS k=31 hdist=1 \
  ref="$PHIX" in="$R1" in2="$R2"\
  out=/data/trim_reads/"$B"-noPhiX-R1.fsq out2=/data/trim_reads/"$B"-noPhiX-R2.fsq\
  qin=auto qout=33 overwrite=t