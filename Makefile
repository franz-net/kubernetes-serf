VERSION      ?= latest
IMAGE_REPO   ?= franzenet/serf
SERF_VERSION ?= 0.8.2

.PHONY: all prep clean build tag push clean
all: clean prep build tag push
	echo "Done! ${IMAGE_REPO}:${VERSION}"

prep:
	unzip -d . upstream/serf_${SERF_VERSION}_linux_amd64.zip

clean:
	rm -f serf

build: clean prep
	docker build -t ${IMAGE_REPO} .

tag:
	docker tag ${IMAGE_REPO} ${IMAGE_REPO}:${VERSION}

push:
	docker push franzenet/serf:${VERSION}
