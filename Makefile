default: build push

build:
	docker build -t quadrabee/k8s-backup .

push:
	docker push quadrabee/k8s-backup
