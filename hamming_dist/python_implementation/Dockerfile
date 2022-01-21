FROM python:3.8-slim-buster as app

# Necessary for running with nextflow
RUN apt-get update && apt-get -y install procps

WORKDIR /
COPY requirements.txt .
RUN pip3 install -r requirements.txt

WORKDIR /usr/local/bin
COPY pairwiseDistances.py .
COPY pairwiseTo2d.py .

# Make executable to all necessary for running with nextflow
RUN chmod a+x *.py

WORKDIR /data

# Build with: docker build --progress=plain -t hamming-dist -f python_implementation/Dockerfile python_implementation
# Run note: the script expects the diectory with the alignment file to be mounted from the local machine
# Run with: docker run --rm --mount type=bind,source="$(pwd)",target=/data hamming-dist pairwiseDistances.py <alignment> > <outfile>
# And then: docker run --rm --mount type=bind,source="$(pwd)",target=/data hamming-dist pairwiseTo2d.py -i <outfile>

