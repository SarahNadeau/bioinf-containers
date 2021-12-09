#!/bin/bash

# This script downloads some FASTA-format consensus sequences and aligns them using ParSNP.

mkdir data && cd data
wget \
https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/698/515/GCA_000698515.1_CFSAN000661_01.0/GCA_000698515.1_CFSAN000661_01.0_genomic.fna.gz \
https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/749/005/GCA_000749005.1_CFSAN000669_01.0/GCA_000749005.1_CFSAN000669_01.0_genomic.fna.gz

gunzip -k *_genomic.fna.gz
cd ..

parsnp \
-d data \
-o outdir_parsnp \
--use-fasttree \
-v \
-c \
-r ! \
-p $CPUS

#gingr outdir_parsnp/parsnp.ggr