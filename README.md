# Bioinformatics Containers

This repository has code to build containers for bioinformatics tools.

## Automated Testing
The goal is to have testing baked into images. So, a container can't be pushed to an external repository until tests pass.

This is done using multistage dockerfiles and GitHub Actions.

### Multistage Dockerfile

Each Dockerfile contains different endpoints for testing and for deployment. 
I call these stages "test" and "app". They can be built off of a base image (e.g. `FROM ubuntu:xenial as app`) or an earlier set-up & installation stage (e.g. `FROM base as app`). 

See, for example, [this Dockerfile](https://github.com/SarahNadeau/docker-playground/blob/master/test_python_example/Dockerfile).

```
# Test with: docker build --target=test -t <image name> <context directory>
# Build with: docker build --target=app -t <image name> <context directory>
```

The multistage Dockerfile means files for testing don't clutter up the production container.

### GitHub Actions
I use GitHub Actions to sit between the GitHub code base and the released production container on Dockerhub.
The actions workflow automatically builds the test stage of a container at some specified frequency, up to every new commit and pull request. 
Only if the test build succeeds, the production container is built and automatically pushed to Dockerhub.

See, for example, this GitHub [workflow specification](https://github.com/SarahNadeau/docker-playground/blob/master/.github/workflows/test-python-docker-image.yml). Or, [this one](https://github.com/SarahNadeau/docker-playground/blob/master/.github/workflows/build_and_push.yml), which shows how to exploit common workflows that can be re-used across containers.

These workflows ensure that only containers passing the baked-in tests are released.