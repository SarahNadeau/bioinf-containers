FROM ubuntu:xenial

RUN apt-get upgrade && apt-get update && apt-get install -y \
    bioperl

RUN mkdir app/
COPY pairwiseDistances.pl app/

WORKDIR data/

ENTRYPOINT [ "perl", "/app/pairwiseDistances.pl" ]

# Build with: docker build -t get_dist_perl -f perl_implementation/Dockerfile perl_implementation
# Run note: the script expects the diectory with the alignment file to be mounted from the local machine
# Run with: docker run --rm --mount type=bind,source="$(pwd)",target=/data get_dist_perl <alignment> > <outfile>