FROM python:3.8-slim-buster as app

# necessary for running with nextflow
RUN apt-get update && apt-get -y install procps

WORKDIR /
COPY requirements.txt .
RUN pip3 install -r requirements.txt

WORKDIR /usr/local/bin
COPY calc_hamming_dist.py .
# make executable to all necessary for running with nextflow
RUN chmod a+x calc_hamming_dist.py

WORKDIR /data

# Build with: docker build --progress=plain -t hamming-dist -f python_implementation/Dockerfile python_implementation
# Run note: the script expects the diectory with the alignment file to be mounted from the local machine
# Run with: docker run --rm --mount type=bind,source="$(pwd)",target=/data hamming-dist calc_hamming_dist.py <alignment> > <outfile>


