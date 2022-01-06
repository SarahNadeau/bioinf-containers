FROM ubuntu:xenial as builder

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

FROM builder as app
# Not actually saving space with this layer, just mirroring format of other Dockerfiles
# To save space with FROM ubuntu:xenial, would have to copy over java into app

RUN mkdir -p {scripts,in,out}

ENV PHIX=/bbmap/resources/phix174_ill.ref.fa.gz
ENV O=/out

WORKDIR data/

# Run bbduk & accessory logging code, re-direct stdout and stderr to log file
ENTRYPOINT bash -c "mkdir -p /out/.log; bash /remove_phix.sh &> $O/.log/TrimAsmAnnot.${B}"

FROM app as test

RUN mkdir ../tests/
COPY tests/ ../tests/
RUN python3 -m unittest discover -v -s ../tests