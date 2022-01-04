## Remove any PhiX from Illumina reads

This project implements [BBDuk](https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide/bbduk-guide/) in a docker container to remove lingering PhiX reads from Illumina sequencing output.

### Notes

It uses the PhiX version packaged with BBMap, I couldn't find PhiX_NC_001422.1.fasta.