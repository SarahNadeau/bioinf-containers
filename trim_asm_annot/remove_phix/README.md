## Remove PhiX from Illumina reads

This project implements [BBDuk](https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide/bbduk-guide/) in a docker container to remove lingering PhiX reads from Illumina sequencing output.

### Notes

* It uses the PhiX version packaged with BBMap, I couldn't find PhiX_NC_001422.1.fasta.
* I had to replace UGE's stdout logging
  * No more JOB_ID variable
  * bbduk.sh stdout and stderr redirected to a log file (now without JOBID suffix).
  * Nothing is printed out to stdout when the container is run :(

### Build the image
```
docker build -t remove-phix --progress=plain remove_phix
```

### Run a container
Run notes
- scripts are mapped into the container
- TODO: copy scripts into container once stable
- container expects environment variables R1, R2, and B to be set

Get toy data
```
bash tests/scripts/run_positive_control.sh
```
Set environment variables
```
# working directory is `trim_asm_annot`
IN="$(pwd)"/pos_control/input_dir
OUT="$(pwd)"/pos_control/output_dir
R1=TESTX_H7YRLADXX_S1_L001_R1_001.fastq.gz
R2=TESTX_H7YRLADXX_S1_L001_R2_001.fastq.gz
B=TESTX_H7YRLADXX_S1_L001
```
Run the container
```
# MIN_OUTSIZE normally not needed, here only because the toy data is tiny
docker run \
--rm \
--mount type=bind,src="$(pwd)"/shared_scripts,dst=/shared_scripts \
--mount type=bind,src="$(pwd)"/remove_phix/remove_phix.sh,dst=/remove_phix.sh \
--mount type=bind,src=${OUT},dst=/out \
--mount type=bind,src=${IN}/${R1},dst=/in/${R1} \
--mount type=bind,src=${IN}/${R2},dst=/in/${R2} \
--env B=${B} \
--env R1=in/${R1} \
--env R2=in/${R2} \
--env MIN_OUTSIZE="10 B" \
remove-phix 
```