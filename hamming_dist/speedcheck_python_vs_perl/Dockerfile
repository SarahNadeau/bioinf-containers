# Use xenial because bioperl install on ubuntu 20.04 doesn't work for Perl script
FROM ubuntu:xenial
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    bioperl \
    python-software-properties \
    software-properties-common \
    wget

# Use python3.6 because Biopython requires Python 3.6 or later and ubuntu 18.04 installs 3.5
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt update && \
    apt install -y python3.6

RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3.6 get-pip.py
RUN ln -s /usr/bin/python3.6 /usr/local/bin/python3

WORKDIR app/
COPY python_implementation/requirements.txt requirements.txt
RUN pip3.6 install -r requirements.txt

ENTRYPOINT [ "bash", "speedcheck_python_vs_perl/speedcheck.sh" ]

# Build with: docker build -t speedcheck -f speedcheck_python_vs_perl/Dockerfile .
# Run note: container expects hamming_dist to be a bound working directory, uses the most working versions of perl & python implementations, speedcheck.sh from there
# Run with: docker run --rm --mount type=bind,source="$(pwd)",target=/app speedcheck