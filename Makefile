DOCKER_TAG := $(or ${DOCKER_TAG},${DOCKER_TAG},latest)

default: image push

image:
	docker build -t quadrabee/k8s-backup:${DOCKER_TAG} .

image.push:
	docker push quadrabee/k8s-backup:${DOCKER_TAG}
