#!/bin/bash
# This script pulls real data and runs parsnp on it. It writes out the sha256 checksum of output files for testing.
# Note: "The single-threaded version of FastTree is deterministic and rerunning the same version of FastTree on the same alignment on the same computer with the same settings should give identical results" (from: http://www.microbesonline.org/fasttree/).
# Note: "...there is a degree of randomness to Parsnps results" (from: https://github.com/marbl/parsnp/issues/6) but there's no option to set a seed and I don't know where this randomness is introduced. See if the test ever fails?

mkdir -p input_dir
mkdir -p reference
cd input_dir
wget \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/439/415/GCA_000439415.1_ASM43941v1/GCA_000439415.1_ASM43941v1_genomic.fna.gz \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/698/515/GCA_000698515.1_CFSAN000661_01.0/GCA_000698515.1_CFSAN000661_01.0_genomic.fna.gz \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/749/005/GCA_000749005.1_CFSAN000669_01.0/GCA_000749005.1_CFSAN000669_01.0_genomic.fna.gz \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/749/065/GCA_000749065.1_CFSAN000752_01.0/GCA_000749065.1_CFSAN000752_01.0_genomic.fna.gz
#    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/749/045/GCA_000749045.1_CFSAN000700_01.0/GCA_000749045.1_CFSAN000700_01.0_genomic.fna.gz  # has no snps (missing?) --> ParSNP falls back on FastTree always
gunzip ./*.gz
mv
cd ../
mv input_dir/GCA_000439415.1_ASM43941v1_genomic.fna reference/GCA_000439415.1_ASM43941v1_genomic_OUTGROUP.fna

# Run using RAxML
RAXML_OUTDIR=outdir_parsnp_raxml
parsnp \
-d input_dir \
-o $RAXML_OUTDIR \
-v \
-c \
-r reference/GCA_000439415.1_ASM43941v1_genomic_OUTGROUP.fna

# Run using FastTree
FASTTREE_OUTDIR=outdir_parsnp_fasttree
parsnp \
-d input_dir \
-o  $FASTTREE_OUTDIR \
--use-fasttree \
-v \
-c \
-r reference/GCA_000439415.1_ASM43941v1_genomic_OUTGROUP.fna

# Output alignment file hashes for testing
sha256sum $FASTTREE_OUTDIR/parsnp.xmfa > $FASTTREE_OUTDIR/parsnp.xmfa.checksum
sha256sum $RAXML_OUTDIR/parsnp.xmfa > $RAXML_OUTDIR/parsnp.xmfa.checksum

# Outpush treefile hashes for testing
sha256sum $FASTTREE_OUTDIR/parsnp.tree > $FASTTREE_OUTDIR/parsnp.tree.checksum
sha256sum $RAXML_OUTDIR/parsnp.tree > $RAXML_OUTDIR/parsnp.tree.checksum

