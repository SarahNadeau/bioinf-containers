FROM python:3.8-slim-buster as app

WORKDIR /
COPY requirements.txt .
RUN pip3 install -r requirements.txt

WORKDIR /usr/local/bin
COPY calc_hamming_dist.py .
RUN chmod u+x calc_hamming_dist.py

WORKDIR /data

# Build with: docker build --progress=plain -t get_dist -f python_implementation/Dockerfile python_implementation
# Run note: the script expects the diectory with the alignment file to be mounted from the local machine
# Run with: docker run --rm --mount type=bind,source="$(pwd)",target=/data get_dist <alignment> > <outfile>


