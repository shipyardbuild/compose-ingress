IMAGE_NAME=gcr.io/shipyard-infra/compose-ingress
IMAGE_VERSION=1.0.1

develop: clean build run
release: build tag push

clean:
	docker-compose stop -t0
	docker-compose rm -f

build:
	docker-compose build

tag:
	docker tag $(IMAGE_NAME):latest $(IMAGE_NAME):$(IMAGE_VERSION)

push:
	docker push $(IMAGE_NAME):latest
	docker push $(IMAGE_NAME):$(IMAGE_VERSION)

run:
	docker-compose up

shell:
	docker-compose run ingress sh
