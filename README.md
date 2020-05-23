# docker-benchmark [![feedyard](https://circleci.com/gh/feedyard/docker-benchmark.svg?style=shield)](https://app.circleci.com/pipelines/github/feedyard/docker-benchmark) ![Software License](https://img.shields.io/badge/license-MIT-blue.svg)  

`feedyard/docker-benchmark` is an alpine-based Docker image designed for use in continuous integration  
builds. As the name suggests, this image will perform Docker benchmark tests of a specified Docker  
image based on the [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker/).  

Uses [inspec](https://www.inspec.io) and the section 4 controls from the [dev-sec/cis-docker-benchmark](https://github.com/dev-sec/cis-docker-benchmark) profile.

## how to use

The running tests expect the image being tested to exist in the local Docker images.  

Inspec controls from Section 4 of the dev-sec benchmark are included in the `docker-benchmark` image.  
When run, the entrypoint command will launch inspec using the copied controls.  

Benchmark 4.8 file permission checks require an `exec` connection to a running instance of the image.  
For distroless images you can bypass this check by including `distroless` as a run parameter.  

**shell script example**

```bash
#!/bin/bash
_() { docker rm -f "$CID" ; }
trap _ EXIT
set -o pipefail

# assumes the following ENV variables
#
# $IMAGENAME = name of the Docker image to test, with out the tag
# $IMAGETAG = image tag to test
# $IMAGESHELL = shell installed in image to use for exec test. default is /bin/bash
# $CONTAINERUSER = from USER command in Dockerfile

echo "run cis docker benchmark inspec test"

# run the image being tested to support control 1,6 & 8
CID=$(docker run -it -d --name cis-test-"${IMAGENAME}" \
                 --entrypoint "${IMAGESHELL}" "${IMAGENAME}":"${IMAGETAG}")

# run docker-benchmark to perform inspec tests
docker run -it \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -e IMAGE_NAME="$IMAGENAME" \
           -e IMAGE_TAG="$IMAGETAG" \
           -e CONTAINER_USER="$CONTAINERUSER" \
           -e CID="$CID" \
           feedyard/docker-benchmark "${1:- standard}"
```
or if using a distroless image, skip 4.8 by including `distroless` in entrypoint parameters  

```bash

# skip running the image being tested

docker run -it \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -e IMAGE_NAME="$IMAGENAME" \
            -e IMAGE_TAG="$IMAGETAG" \
            -e CONTAINER_USER="$CONTAINERUSER" \
            -e CID="$CID" \
            feedyard/docker-benchmark distroless
```
**CircleCI example**

```yaml
- run:
    command: |
      docker run -it \
                  -v /var/run/docker.sock:/var/run/docker.sock \
                  -e IMAGE_NAME="myorganization/myimage" \
                  -e IMAGE_TAG="$CIRCLE_SHA1" \
                  -e CONTAINER_IMAGE="myuser"
                  -e CID="$CID" \
                  feedyard/docker-benchmark distroless
```

<div align="center">
	<p>
		<img alt="Docker Logo" src="https://raw.github.com/CircleCI-Public/cimg-base/master/img/circle-docker.svg?sanitize=true" width="75" />
	</p>
</div>
