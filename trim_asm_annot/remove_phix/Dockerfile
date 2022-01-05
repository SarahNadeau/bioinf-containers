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