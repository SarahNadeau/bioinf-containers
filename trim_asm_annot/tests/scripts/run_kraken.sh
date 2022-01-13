#!/bin/bash
# This script runs test data through Kraken, generating a sha256 checksum of the output.
# Run from working directory `trim_asm_annot`
# Run as: tests/scripts/run_kraken.sh

docker pull staphb/kraken:1.0  # will pull the image, unless it is already available locally

docker run staphb/kraken:1.0 kraken --version

# Outside the container
OUT="$(pwd)"/pos_control/output_dir_spiked_PhiX/trim_reads
B=TESTX_H7YRLADXX_S1_L001
CONTAINER_NAME=staphb-kraken
N_READS_TO_TEST=1000

# Inside the container
KRAKEN_DEFAULT_DB=/kraken-database/minikraken_20171013_4GB

mkdir -p "$OUT"

# Make sure files are small enough to run in reasonable time and compress input for kraken
N_LINES=$(($N_READS_TO_TEST*4))
echo "Running kraken on $N_READS_TO_TEST reads ($N_LINES lines of fastq file)"
for S in assembled unassembled.forward unassembled.reverse; do
  cat "$OUT"/"$B"."$S".fastq | paste - - - - | sort -k1,1 -t " " | tr "\t" "\n" \
  | head -n $N_LINES | gzip -f > "$OUT"/"$B"."$S"_head$N_LINES.fastq.gz
done

docker run \
  --name $CONTAINER_NAME \
  --mount type=bind,src="${OUT}",dst=/data/trim_reads \
  --env KRAKEN_DEFAULT_DB=$KRAKEN_DEFAULT_DB \
  staphb/kraken:1.0 /bin/bash -c "kraken \
    --fastq-input \
    --gzip-compressed \
    trim_reads/\"$B\".unassembled.forward_head$N_LINES.fastq.gz \
    trim_reads/\"$B\".unassembled.reverse_head$N_LINES.fastq.gz \
    trim_reads/\"$B\".assembled_head$N_LINES.fastq.gz > trim_reads/kraken_output.txt;
    kraken-report trim_reads/kraken_output.txt > trim_reads/\"$B\"_kraken.tab"

rm -f "$OUT"/checksums_$CONTAINER_NAME.txt
for F in "$OUT"/kraken_output.txt "$OUT"/"$B"_kraken.tab; do
  # Thanks: https://edwards.flinders.edu.au/sorting-fastq-files-by-their-sequence-identifiers/
  shasum -a 256 $F >> "$OUT"/checksums_$CONTAINER_NAME.txt
done

docker logs $CONTAINER_NAME > "$OUT"/${CONTAINER_NAME}_stdout.log 2> "$OUT"/${CONTAINER_NAME}_stderr.log

docker container rm $CONTAINER_NAME