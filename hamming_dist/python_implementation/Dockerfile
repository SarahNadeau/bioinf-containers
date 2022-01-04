FROM python:3.8-slim-buster

RUN mkdir app/
COPY calc_hamming_dist.py app/
COPY requirements.txt app/
RUN pip3 install -r app/requirements.txt

WORKDIR data/

ENTRYPOINT [ "python3", "/app/calc_hamming_dist.py" ]

# Build with: docker build -t get_dist -f python_implementation/Dockerfile python_implementation
# Run note: the script expects the diectory with the alignment file to be mounted from the local machine
# Run with: docker run --rm --mount type=bind,source="$(pwd)",target=/data get_dist <alignment> > <outfile>


