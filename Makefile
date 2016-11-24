VERSION = 0.0.1

CREATE_DATE := $(shell date +%FT%T%Z)
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(shell dirname $(MKFILE_PATH))
DOCKER_BIN := $(shell which docker)

REGISTRY_CURRENT_VERSION = 2.4.1
REGISTRY_IMAGES = 2.4.1


all: build test

.PHONY: check.env
check.env:
ifndef DOCKER_BIN
   $(error The docker command is not found. Verify that Docker is installed and accessible)
   endif

./bin/registry -version


.PHONE: registry
registry:
    @for img_ver in $(REGISTRY_IMAGES); \
    do \
    echo " " ; \
    echo " " ; \
    echo "Building '$$img_ver $@' image..." ; \
    $(DOCKER_BIN) build --rm -t $(REGISTRY)/$@:$$img_ver $(CURRENT_DIR)/$@/$$img_ver ; \
    cp -pR $(CURRENT_DIR)/templates/$@/README.md $(CURRENT_DIR)/$@/$$img_ver/README.md ; \
    sed -i 's/###-->ZZZ_IMAGE<--###/$(REGISTRY)\/$@/g' $(CURRENT_DIR)/$@/$$img_ver/README.md ; \
    sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' $(CURRENT_DIR)/$@/$$img_ver/README.md ; \
    sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(REGISTRY)\/golang:1.6-alpine/g' $(CURRENT_DIR)/$@/$$img_ver/README.md ; \
    sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/$@/$$img_ver/README.md ; \
    sed -i "s/###-->ZZZ_REGISTRY_VERSION<--###/$$img_ver/g" $(CURRENT_DIR)/$@/$$img_ver/README.md ; \
    sed -i "s/###-->ZZZ_CURRENT_VERSION<--###/$(REGISTRY_CURRENT_VERSION)/g" $(CURRENT_DIR)/$@/$$img_ver/README.md ; \
    done

.PHONE: registry_test
registry:test:
    @for registry_ver in $(REGISTRY_IMAGES); \
    do \
    echo "Testing '$$registry_ver registry' image..." ; \
    echo " " ; \
    if ! $(DOCKER_BIN) run -it \
        $(REGISTRY)/registry:$$registry_ver version | \
        grep -q -F "Registry v$$registry_ver" ; then echo "$(REGISTRY)/registry:$$registry_ver - registry version command failed."; false; fi; \
    done

.PHONY: release
release:
    $(DOCKER_BIN) tag $(REGISTRY)/registry:$(REGISTRY_CURRENT_VERSION) $(NAME)/registry:latest
    $(DOCKER_BIN) push $(REGISTRY)/registry

.PHONY: clean
clean: clean_untagged

.PHONY: clean_untagged
clean_untagged: clean_stopped
    docker images --no-trunc | grep none | awk '{print $$3}' | xargs -r docker rmi

.PHONY: clean_stopped
clean_stopped:
    for i in `docker ps --no-trunc -a -q`;do docker rm $$i;done
