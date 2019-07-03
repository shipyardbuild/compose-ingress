IMAGE_NAME=shipyardbuild/compose-ingress
IMAGE_VERSION=1.0.1

develop: clean build run

clean:
	docker-compose stop -t0
	docker-compose rm -f

build:
	docker-compose build

run:
	docker-compose up

shell:
	docker-compose run ingress sh

version: clean build
	@# Commit and tag the new version
	git add Makefile
	git commit -m "v$(IMAGE_VERSION)"
	git tag -a "v$(IMAGE_VERSION)" -m "v$(IMAGE_VERSION)"
	@# Tag the latest and version images
	docker tag $(IMAGE_NAME):dev $(IMAGE_NAME):latest
	docker tag $(IMAGE_NAME):dev $(IMAGE_NAME):$(IMAGE_VERSION)
	@# Push the images to registry
	docker push $(IMAGE_NAME):latest
	docker push $(IMAGE_NAME):$(IMAGE_VERSION)
