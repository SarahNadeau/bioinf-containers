#!/bin/bash
# This script pulls real data and runs parsnp on it. It writes out the sha256 checksum of output files for testing.
# Note: "The single-threaded version of FastTree is deterministic and rerunning the same version of FastTree on the same alignment on the same computer with the same settings should give identical results" (from: http://www.microbesonline.org/fasttree/).
# Note: "...there is a degree of randomness to Parsnps results" (from: https://github.com/marbl/parsnp/issues/6) but there's no option to set a seed and I don't know where this randomness is introduced. See if the test ever fails?

OUTGROUP_STRAIN="GCA_000703365.1_Ec2011C-3609_genomic"
mkdir -p input_dir
mkdir -p reference
cd input_dir
wget \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/703/365/GCA_000703365.1_Ec2011C-3609/GCA_000703365.1_Ec2011C-3609_genomic.fna.gz \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/016/766/575/GCA_016766575.1_PDT000040717.5/GCA_016766575.1_PDT000040717.5_genomic.fna.gz \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/003/018/935/GCA_003018935.1_ASM301893v1/GCA_003018935.1_ASM301893v1_genomic.fna.gz \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/012/830/055/GCA_012830055.1_PDT000040719.3/GCA_012830055.1_PDT000040719.3_genomic.fna.gz \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/012/829/335/GCA_012829335.1_PDT000040724.3/GCA_012829335.1_PDT000040724.3_genomic.fna.gz \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/003/018/775/GCA_003018775.1_ASM301877v1/GCA_003018775.1_ASM301877v1_genomic.fna.gz \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/012/829/275/GCA_012829275.1_PDT000040726.3/GCA_012829275.1_PDT000040726.3_genomic.fna.gz \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/016/766/555/GCA_016766555.1_PDT000040728.5/GCA_016766555.1_PDT000040728.5_genomic.fna.gz \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/012/829/195/GCA_012829195.1_PDT000040729.3/GCA_012829195.1_PDT000040729.3_genomic.fna.gz \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/012/829/295/GCA_012829295.1_PDT000040727.3/GCA_012829295.1_PDT000040727.3_genomic.fna.gz
gunzip ./*.gz
mv $OUTGROUP_STRAIN.fna ../reference/${OUTGROUP_STRAIN}_OUTGROUP.fna
cd ../

# Run using RAxML
#RAXML_OUTDIR=outdir_parsnp_raxml
#parsnp \
#-d input_dir \
#-o $RAXML_OUTDIR \
#-v \
#-c \
#-r reference/${OUTGROUP_STRAIN}_OUTGROUP.fna

# Run using FastTree
FASTTREE_OUTDIR=outdir_parsnp_fasttree
parsnp \
-d input_dir \
-o  $FASTTREE_OUTDIR \
--use-fasttree \
-v \
-c \
-r reference/${OUTGROUP_STRAIN}_OUTGROUP.fna

# Generate SNP alignment files (for debugging)
harvesttools -i $FASTTREE_OUTDIR/parsnp.ggr -S $FASTTREE_OUTDIR/snp_alignment.txt
#harvesttools -i $RAXML_OUTDIR/parsnp.ggr -S $RAXML_OUTDIR/snp_alignment.txt

# Output alignment file hashes for testing
sha256sum $FASTTREE_OUTDIR/parsnp.xmfa > $FASTTREE_OUTDIR/parsnp.xmfa.checksum
#sha256sum $RAXML_OUTDIR/parsnp.xmfa > $RAXML_OUTDIR/parsnp.xmfa.checksum

# Output treefile hashes for testing
sha256sum $FASTTREE_OUTDIR/parsnp.tree > $FASTTREE_OUTDIR/parsnp.tree.checksum
#sha256sum $RAXML_OUTDIR/parsnp.tree > $RAXML_OUTDIR/parsnp.tree.checksum

