#!/bin/bash
# This script pulls real data and runs bbduk on it to filter out PhiX reads.
# TODO: spike in PhiX reads
# TODO: writes out the sha256 checksum of output files for testing.

mkdir -p pos_control/input_dir
cd pos_control/input_dir
# Thanks: https://github.com/hartwigmedical/testdata
wget \
    https://github.com/hartwigmedical/testdata/raw/master/100k_reads_hiseq/TESTX/TESTX_H7YRLADXX_S1_L001_R1_001.fastq.gz \
    https://github.com/hartwigmedical/testdata/raw/master/100k_reads_hiseq/TESTX/TESTX_H7YRLADXX_S1_L001_R2_001.fastq.gz