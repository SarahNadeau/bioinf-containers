FROM ubuntu:xenial

ARG BBMAP_VER=38.94
ARG JAVA_VER=11

RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget

# Install Java
RUN add-apt-repository ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y openjdk-${JAVA_VER}-jre

# Install BBMap, which contains the PhiX genome
RUN wget https://sourceforge.net/projects/bbmap/files/BBMap_$BBMAP_VER.tar.gz/download
RUN tar -xvzf download && rm download

RUN mkdir scripts
WORKDIR data/

ENV PHIX=/bbmap/resources/phix174_ill.ref.fa.gz

ENTRYPOINT ["bash", "/scripts/remove_phix.sh"]

# Build with: docker build -t remove-phix --progress=plain .
# Run notes:
#   - remove_phix.sh is mapped into the container, TODO: package remove_phix.sh with the container once stable
#   - container expects environment variables R1, R2, and B to be set, they are paired fastq.gz files in the mapped in input directory and their base name
# Test with:
#   # Download test data
#   ./tests/scripts/run_positive_control.sh
#   # Run container
#   docker run --rm --mount type=bind,src="$(pwd)"/pos_control/input_dir,dst=/data --mount type=bind,src="$(pwd)"/remove_phix.sh,dst=/scripts/remove_phix.sh --env R1=TESTX_H7YRLADXX_S1_L001_R1_001.fastq.gz --env R2=TESTX_H7YRLADXX_S1_L001_R2_001.fastq.gz --env B=TESTX_H7YRLADXX_S1_L001 remove-phix