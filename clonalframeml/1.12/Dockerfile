ARG CLONALFRAMEML_VER="1.12"

FROM ubuntu:xenial as builder
ARG CLONALFRAMEML_VER

LABEL base.image="ubuntu:xenial"
LABEL software="ClonalFrameML"
LABEL software.version=${CLONALFRAMEML_VER}
LABEL description="ClonalFrameML: Maximum-likelihood inference of recombination in bacterial genomes."
LABEL website="https://github.com/xavierdidelot/ClonalFrameML"
LABEL license.url="https://github.com/xavierdidelot/ClonalFrameML/blob/master/LICENSE"

# Update package index, install packages for building from source
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    software-properties-common \
    dirmngr \
    apt-transport-https

# Install ClonalFrameML from source
WORKDIR /
RUN wget https://github.com/xavierdidelot/ClonalFrameML/archive/refs/tags/v$CLONALFRAMEML_VER.tar.gz
RUN tar xvf v$CLONALFRAMEML_VER.tar.gz && rm v$CLONALFRAMEML_VER.tar.gz
WORKDIR /ClonalFrameML-$CLONALFRAMEML_VER/src
RUN make
RUN cp /ClonalFrameML-$CLONALFRAMEML_VER/src/ClonalFrameML /usr/local/bin/ClonalFrameML

# Install R from CRAN (thanks: https://linuxize.com/post/how-to-install-r-on-ubuntu-20-04/)
# Add GPG key to trust the repository
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
# Pull R 4.X.X for ubuntu 16.04 (xenial) & update package repository accordingly
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu xenial-cran40/" && apt update
# Install R
RUN apt install -y r-base

# Add the R 4.0 or later ‘c2d4u’ repository
RUN add-apt-repository ppa:c2d4u.team/c2d4u4.0+ && apt update
# Install the ape and phangorn R packages.
RUN apt install -y \
    r-cran-ape \
    r-cran-phangorn

FROM ubuntu:xenial as app
ARG CLONALFRAMEML_VER

COPY --from=builder /usr/ /usr/
# Fix symlink problem after COPY
RUN mv /usr/lib/libblas/* /usr/lib/ && mv /usr/lib/lapack/* /usr/lib/

RUN mkdir -p /data
WORKDIR /data

FROM app as test

RUN apt-get update && apt-get install -y python3

ENV PATH=/usr/:$PATH

RUN mkdir ../tests/
COPY tests/ ../tests/
RUN python3 -m unittest discover -v -s ../tests

# Test with: docker build --target=test -t clonalframeml --progress=plain .
# Build with: docker build --target=app -t clonalframeml --progress=plain .
# Run R with: docker run --rm clonalframeml R --version
# Run ClonalFrameML with: docker run --rm clonalframeml ClonalFrameML -version