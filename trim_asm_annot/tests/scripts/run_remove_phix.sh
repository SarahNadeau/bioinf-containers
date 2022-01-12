#!/bin/bash
# This script runs test data through bbduk, generating a sha256 checksum of the output.
# Run from working directory `trim_asm_annot`
# Run as: tests/scripts/run_remove_phix.sh

docker pull staphb/bbtools:38.94  # will pull the latest version, unless latest is already available

docker run staphb/bbtools:38.94 bbduk.sh --version

# Outside the container
IN="$(pwd)"/pos_control/input_dir
OUT="$(pwd)"/pos_control/output_dir_spiked_PhiX/trim_reads
R1=TESTX_H7YRLADXX_S1_L001_spikedPhiX_R1_001.fastq
R2=TESTX_H7YRLADXX_S1_L001_spikedPhiX_R2_001.fastq
B=TESTX_H7YRLADXX_S1_L001
CONTAINER_NAME=staphb

# Inside the container
PHIX="/bbmap/resources/phix174_ill.ref.fa.gz"

mkdir -p $OUT

# Name container, don't log
docker run \
  --name $CONTAINER_NAME \
  --mount type=bind,src=${OUT},dst=/data/trim_reads \
  --mount type=bind,src=${IN}/${R1},dst=/data/${R1} \
  --mount type=bind,src=${IN}/${R2},dst=/data/${R2} \
  --env PHIX=$PHIX \
  staphb/bbtools:38.94 bbduk.sh \
    k=31 \
    hdist=1 \
    ref="$PHIX" \
    in="$R1" \
    in2="$R2"\
    out=trim_reads/"$B"-noPhiX-R1.fsq \
    out2=trim_reads/"$B"-noPhiX-R2.fsq \
    qin=auto \
    qout=33 \
    overwrite=t

for R in R1 R2; do
  # Thanks: https://edwards.flinders.edu.au/sorting-fastq-files-by-their-sequence-identifiers/
  cat $OUT/"$B"-noPhiX-$R.fsq | paste - - - - | sort -k1,1 -t " " | tr "\t" "\n" > $OUT/"$B"-noPhiX-$R.fsq.sorted
  shasum -a 256 $OUT/"$B"-noPhiX-$R.fsq.sorted > $OUT/"$B"-noPhiX-$R.fsq.sorted.checksum
done

docker logs $CONTAINER_NAME > $OUT/stdout.log 2>$OUT/stderr.log

docker container rm $CONTAINER_NAME