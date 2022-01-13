#!/bin/bash
# This script runs test data through PEAR, generating a sha256 checksum of the output.
# Run from working directory `trim_asm_annot`
# Run as: tests/scripts/run_merge.sh

docker pull snads/pear:0.9.11  # will pull the image, unless it is already available locally

docker run snads/pear:0.9.11 pear --version

# Outside the container
OUT="$(pwd)"/pos_control/output_dir_staphb_2/trim_reads
B=TESTX_H7YRLADXX_S1_L001
CONTAINER_NAME=snads-pear
OVERLAP_LEN=80  # approx. 0.8 * 101 (read length of toy data)

mkdir -p "$OUT"

docker run \
  --name $CONTAINER_NAME \
  --mount type=bind,src="${OUT}",dst=/data/trim_reads \
  snads/pear:0.9.11 pear \
    -f trim_reads/"$B"_R1.paired.fq \
    -r trim_reads/"$B"_R2.paired.fq \
    -o trim_reads/$B \
    --keep-original \
    --p-value 0.01 \
    --min-overlap \
    $OVERLAP_LEN

rm -f "$OUT"/checksums_$CONTAINER_NAME.txt
for S in discarded assembled unassembled.forward unassembled.reverse; do
  # Thanks: https://edwards.flinders.edu.au/sorting-fastq-files-by-their-sequence-identifiers/
  cat "$OUT"/"$B".$S.fastq | paste - - - - | sort -k1,1 -t " " | tr "\t" "\n" \
  | shasum -a 256 >> "$OUT"/checksums_$CONTAINER_NAME.txt
done

docker logs $CONTAINER_NAME > "$OUT"/${CONTAINER_NAME}_stdout.log 2> "$OUT"/${CONTAINER_NAME}_stderr.log

docker container rm $CONTAINER_NAME