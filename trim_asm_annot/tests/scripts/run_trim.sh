#!/bin/bash
# This script runs test data through trimmomatic, generating a sha256 checksum of the output.
# Run from working directory `trim_asm_annot`
# Run as: tests/scripts/run_trim.sh

docker pull staphb/trimmomatic:0.39

docker run staphb/trimmomatic:0.39 trimmomatic -version

# Outside the container
OUT="$(pwd)"/pos_control/output_dir_staphb/trim_reads
B=TESTX_H7YRLADXX_S1_L001
CONTAINER_NAME=staphb-trimmomatic

# Inside the container
#ADAPTERS=$LAB_HOME/.lib/adapters_Nextera_NEB_TruSeq_NuGEN_ThruPLEX.fas
ADAPTERS=/Trimmomatic-0.39/adapters/TruSeq3-PE.fa  # trimmomatic docs says these are used in HiSeq and MiSeq machines

mkdir -p $OUT

docker run \
  --name $CONTAINER_NAME \
  --mount type=bind,src=${OUT},dst=/data/trim_reads \
  staphb/trimmomatic:0.39 trimmomatic \
    PE \
    -phred33 \
    trim_reads/"$B"-noPhiX-R1.fsq trim_reads/"$B"-noPhiX-R2.fsq \
    trim_reads/"$B"_R1.paired.fq trim_reads/"$B"_R1.unpaired.fq \
    trim_reads/"$B"_R2.paired.fq trim_reads/"$B"_R2.unpaired.fq \
    ILLUMINACLIP:$ADAPTERS:2:20:10:8:TRUE \
    SLIDINGWINDOW:6:30 LEADING:10 TRAILING:10 MINLEN:50

rm -f $OUT/checksums_$CONTAINER_NAME.txt
for R in R1 R2; do
  for P in paired unpaired; do
    # Thanks: https://edwards.flinders.edu.au/sorting-fastq-files-by-their-sequence-identifiers/
    cat "$OUT"/"$B"_$R.$P.fq | paste - - - - | sort -k1,1 -t " " | tr "\t" "\n" \
    | shasum -a 256 "$OUT"/"$B"_$R.$P.fq.sorted >> "$OUT"/checksums_$CONTAINER_NAME.txt
    rm "$OUT"/"$B"_$R.$P.fq.sorted
  done
done

docker logs $CONTAINER_NAME > "$OUT"/${CONTAINER_NAME}_stdout.log 2> "$OUT"/${CONTAINER_NAME}_stderr.log

docker container rm $CONTAINER_NAME

