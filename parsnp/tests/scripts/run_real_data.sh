#!/bin/bash
# This script pulls real data and runs parsnp on it. It returns the sha256 checksum of the tree output file.
# TODO: make sure no bits of the alignment or tree search are heuristic, or set a seed

mkdir -p input_dir
cd input_dir
wget \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/698/515/GCA_000698515.1_CFSAN000661_01.0/GCA_000698515.1_CFSAN000661_01.0_genomic.fna.gz \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/749/005/GCA_000749005.1_CFSAN000669_01.0/GCA_000749005.1_CFSAN000669_01.0_genomic.fna.gz
gunzip *.gz
cd ../

parsnp \
-d input_dir \
-o outdir_parsnp \
--use-fasttree \
-v \
-c \
-r input_dir/GCA_000698515.1_CFSAN000661_01.0_genomic.fna

sha256sum outdir_parsnp/parsnp.tree > outdir_parsnp/parsnp.tree.checksum

