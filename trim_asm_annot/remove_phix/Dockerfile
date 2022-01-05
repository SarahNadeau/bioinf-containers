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

RUN mkdir -p {scripts,in,out,out/.log}

ENV PHIX=/bbmap/resources/phix174_ill.ref.fa.gz
ENV O=/out

# Re-direct stdout and stderr to log file
ENTRYPOINT bash -c "bash remove_phix.sh &> $O/.log/TrimAsmAnnot.${B}"

# Build with:
#   docker build -t remove-phix --progress=plain remove_phix
#
# Run notes:
#   - scripts are mapped into the container, TODO: copy scripts into container once stable
#   - container expects environment variables R1, R2, and B to be set
#
# Test with:
#    IN="$(pwd)"/pos_control/input_dir
#    OUT="$(pwd)"/pos_control/output_dir
#    R1=TESTX_H7YRLADXX_S1_L001_R1_001.fastq.gz
#    R2=TESTX_H7YRLADXX_S1_L001_R2_001.fastq.gz
#    B=TESTX_H7YRLADXX_S1_L001
#
#    docker run \
#    --rm \
#    --mount type=bind,src="$(pwd)"/shared_scripts,dst=/shared_scripts \
#    --mount type=bind,src="$(pwd)"/remove_phix/remove_phix.sh,dst=/remove_phix.sh \
#    --mount type=bind,src=${OUT},dst=/out \
#    --mount type=bind,src=${IN}/${R1},dst=/in/${R1} \
#    --mount type=bind,src=${IN}/${R2},dst=/in/${R2} \
#    --env B=${B} \
#    --env R1=in/${R1} \
#    --env R2=in/${R2} \
#    --env MIN_OUTSIZE="10 B" \
#    remove-phix