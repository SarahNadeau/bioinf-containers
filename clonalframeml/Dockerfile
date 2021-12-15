ARG CLONALFRAMEML_VER="1.12"

FROM ubuntu:latest as builder
ARG CLONALFRAMEML_VER
ARG R_VER_PREFIX=4
# Prefix is for link to R source files

# ARG variables only persist during build time
ARG R_VER=4.0.5

LABEL base.image="ubuntu:xenial"
LABEL software="ClonalFrameML"
LABEL software.version=${CLONALFRAMEML_VER}
LABEL description="ClonalFrameML: Maximum-likelihood inference of recombination in bacterial genomes."
LABEL website="https://github.com/xavierdidelot/ClonalFrameML"
LABEL license.url="https://github.com/xavierdidelot/ClonalFrameML/blob/master/LICENSE"

# Update package index, install packages
RUN apt-get update && apt-get install -y \
    build-essential \
    wget

WORKDIR /
RUN wget https://github.com/xavierdidelot/ClonalFrameML/archive/refs/tags/v$CLONALFRAMEML_VER.tar.gz
RUN tar xvf v$CLONALFRAMEML_VER.tar.gz && rm v$CLONALFRAMEML_VER.tar.gz
WORKDIR /ClonalFrameML-$CLONALFRAMEML_VER/src
RUN make

# Add to path
ENV PATH=/ClonalFrameML-$CLONALFRAMEML_VER/src:$PATH

# Running the bundled R scripts requires R to be installed with the ape and phangorn packages.
# Install from source
# See: https://askubuntu.com/questions/496549/error-you-must-put-some-source-uris-in-your-sources-list
RUN sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y build-dep r-base

WORKDIR /
RUN wget https://cran.rstudio.com/src/base/R-$R_VER_PREFIX/R-$R_VER.tar.gz
RUN tar -xzvf R-$R_VER.tar.gz
WORKDIR R-$R_VER
RUN ./configure \
    --prefix=/opt/R/$R_VERSION \
    --enable-memory-profiling \
    --enable-R-shlib \
    --with-blas \
    --with-lapack && \
    make && \
    make install

# Add to path
ENV PATH=/R-4.0.5/bin:$PATH

FROM builder as app
ARG CLONALFRAMEML_VER

COPY --from=builder /ClonalFrameML-$CLONALFRAMEML_VER/ /ClonalFrameML-$CLONALFRAMEML_VER/
# COPY --from=builder /

FROM app as test

RUN apt-get install -y python3

COPY tests/ .
RUN python3 -m unittest

# CLONALFRAMEML_VER="1.12"
# Test with: docker build --target=test -t clonalframeml-$CLONALFRAMEML_VER --progress=plain .
# Build with: docker build --target=app -t clonalframeml-$CLONALFRAMEML_VER --progress=plain .
# Run R with: docker run --rm clonalframeml-$CLONALFRAMEML_VER  R --version
# Run ClonalFrameML with: docker run --rm clonalframeml-$CLONALFRAMEML_VER  ClonalFrameML -version