.POSIX:

# the for loop used for build args appears to be a bashism.
# http://web.archive.org/web/20210516024237/https://ilhicas.com/2018/11/03/docker-build-with-build-arg-wit-multiple-arguments.html
SHELL := bash

WATCHMAN_VERSION = $(shell cat build.args | grep WATCHMAN_VERSION | cut -d'=' -f 2)

REGISTRY ?= ghcr.io/dockwa/watchman
REGISTRY_IMAGE ?= $(WATCHMAN_VERSION)-$(DISTRO)-$(DISTRO_VERSION)

ifeq ($(PUSH),1)
	PUSH_FLAG := --push
endif

.PHONY: buildx-image
buildx-image:
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		-t $(REGISTRY):$(REGISTRY_IMAGE) \
		$(PUSH_FLAG) \
		$$(for i in `cat build.args | grep -vE '(^#|^$$)'`; do out+="--build-arg $$i " ; done; echo $$out;out="") \
		./$(DISTRO)/$(DISTRO_VERSION)
