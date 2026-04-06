IMAGE = band-website
CONTAINER = band-website-dev

ifeq ($(OS),Windows_NT)
    ROOT := $(shell cd)
else
    ROOT := $(shell pwd)
endif

build:
	docker build -t $(IMAGE) .

dev:
	docker run --rm -it \
		--name $(CONTAINER) \
		-p 4321:4321 \
		-v "$(ROOT)/app":/app \
		-v /app/node_modules \
		$(IMAGE) \
		npm run dev

shell:
	docker run --rm -it \
		--name $(CONTAINER) \
		-v "$(ROOT)":/app \
		-v /app/node_modules \
		$(IMAGE) \
		sh

build-site:
	docker run --rm \
		--name $(CONTAINER) \
		-p 4321:4321 \
		-v "$(ROOT)/app":/app \
		-v /app/node_modules \
		$(IMAGE) \
		npm --prefix /app run build

extract-dist:
	docker cp $(CONTAINER):/app/dist ./dist

deploy: build-site
	aws s3 sync app/dist/ s3://thejugs.band --delete