IMAGE := drahy-cns
PORT  := 5557

.PHONY: help dev build test logs stop stage og clean

help:
	@echo "make dev    - rebuild and run on http://localhost:$(PORT)"
	@echo "make build  - build the docker image"
	@echo "make test   - smoke-test the running container"
	@echo "make logs   - follow container logs"
	@echo "make stop   - stop and remove the running container"
	@echo "make stage  - re-fetch SWFs from anat.lf1.cuni.cz"
	@echo "make og     - regenerate og-image.png from og-image.svg"
	@echo "make clean  - stop, remove container and image"

build:
	docker build -t $(IMAGE) .

dev: build stop
	docker run -d --name $(IMAGE) -p $(PORT):5000 $(IMAGE)
	@echo
	@echo "Running at http://localhost:$(PORT)"

test:
	@for path in / /lemniscal-pathway /og-image.png /favicon.svg /healthz /404.html ; do \
	  code=$$(curl -sS -o /dev/null -w '%{http_code}' http://localhost:$(PORT)$$path) ; \
	  printf '  %-25s %s\n' "$$path" "$$code" ; \
	done

logs:
	docker logs -f $(IMAGE)

stop:
	-@docker rm -f $(IMAGE) >/dev/null 2>&1 || true

stage:
	./stage-swfs.sh

og:
	@command -v magick >/dev/null || { echo "ImageMagick (magick) is required" >&2 ; exit 1 ; }
	magick public/og-image.svg public/og-image.png
	@echo "Regenerated public/og-image.png"

clean: stop
	-@docker rmi $(IMAGE) >/dev/null 2>&1 || true
