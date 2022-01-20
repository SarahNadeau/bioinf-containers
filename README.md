# Bioinformatics Containers

This repository has code to build containers for bioinformatics tools.

:warning: Production images are now developed in a [fork of the StaPH-B docker-builds repository](https://github.com/SarahNadeau/docker-builds). 

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

### The Recipe

1. Scope the container: each should do one thing and one thing well.
2. Install the tool and its dependencies in the Dockerfile "builder" stage.
3. Copy over only executables and necessary libraries to "app" stage.

Optional testing steps:
4. Find some small test data.
5. Write python tests checking for expected output from test data.
6. Implement the tests in the "test" stage.

Optional CI step, can operate on multiple related containers (e.g. those used in a pipeline) to test & push all simultaneously:
7. Add a caller workflow to test, build, and push the image(s) to Docker Hub.

