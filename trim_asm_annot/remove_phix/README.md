## Remove any PhiX from Illumina reads

This project implements [BBDuk](https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide/bbduk-guide/) in a docker container to remove lingering PhiX reads from Illumina sequencing output.

### Notes

* It uses the PhiX version packaged with BBMap, I couldn't find PhiX_NC_001422.1.fasta.
* To replace UGE's stdout logging, JOB_ID variable has been removed and the bbduk.sh command's stdout and stderr is redirected to a log file (without any JOBID suffix).
  * As a result, nothing is printed out to stdout when the container is run. This is annoying. So far, tee doesn't help either.