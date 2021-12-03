FROM ubuntu:xenial

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
ARG PARSNP_VER=1.5.6

# Update package index
RUN apt-get update && apt-get upgrade
RUN apt-get install -y wget

# Install miniconda
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

# Install bioconda
RUN conda config --add channels defaults \
    && conda config --add channels bioconda \
    && conda config --add channels conda-forge

# Install parsnp in conda environment
RUN conda create -n parsnp python=3.7 parsnp=$PARSNP_VER

# Run with: docker run parsnp conda run -n parsnp parsnp --version
