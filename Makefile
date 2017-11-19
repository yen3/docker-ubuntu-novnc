IMAGE_NAME=yen3/ubuntu-novnc

# support Darwin and Linux
PLATFORM=$(shell uname)

# Manifest tool - Create a multi-arch docker image
# See https://github.com/estesp/manifest-tool to get more deatils
MANIFEST_TOOL=./manifest-tool

# manifest tool can not use environment setting to set docker username/password
# You have to set as command argument
# e.g.
#      manifest --username <docker-username> --passsword <docker-password> \
#         push from-spec ./manifest.yml
MACOS=

.PHONY: all push amd64 arm aarch64 get-manifest-tool clean

all: amd64 arm aarch64

push: get-manifest-tool
	@# Push image first
	docker push $(IMAGE_NAME):amd64
	docker push $(IMAGE_NAME):arm64
	docker push $(IMAGE_NAME):arm32v7
	@# Create the multi-arch docker image
ifeq ($(PLATFORM),Darwin)
	@# Darwin
	@#
	@# Check the arguement is not empty. If yes, the user does not set username
	@# and password
ifneq ($(MACOS),)
	$(MANIFEST_TOOL) $(MACOS) push from-spec ./manifest.yml
endif
else
	@# Linux
	$(MANIFEST_TOOL) push from-spec ./manifest.yml
endif

amd64:
	docker build -t $(IMAGE_NAME):amd64 .

arm:
ifeq ($(PLATFORM),Darwin)
	@# Darwin
	docker build -t $(IMAGE_NAME):arm32v7 -f Dockerfile_arm32v7 .
else
	@# Linux
	@#
	@# Register binfmt
	docker run --privileged yen3/binfmt-register set arm
	@# build
	docker build -t $(IMAGE_NAME):arm32v7 -f Dockerfile_arm32v7 .
	@# Clear binfmt
	docker run --privileged yen3/binfmt-register clear arm
endif

aarch64:
ifeq ($(PLATFORM),Darwin)
	@# Darwin
	docker build -t $(IMAGE_NAME):arm64 -f Dockerfile_arm64v8 .
else
	@# Linux
	@#
	@# Register binfmt
	docker run --privileged yen3/binfmt-register set aarch64
	@# build
	docker build -t $(IMAGE_NAME):arm64 -f Dockerfile_arm64v8 .
	@# Clear binfmt
	docker run --privileged yen3/binfmt-register clear aarch64
endif

get-manifest-tool:
ifeq (,$(wildcard $(MANIFEST_TOOL)))
ifeq ($(PLATFORM),Darwin)
	@# Darwin
	wget https://github.com/estesp/manifest-tool/releases/download/v0.7.0/manifest-tool-darwin-amd64
	mv manifest-tool-darwin-amd64 $(MANIFEST_TOOL)
else
	@# Linux
	wget https://github.com/estesp/manifest-tool/releases/download/v0.7.0/manifest-tool-linux-amd64
	mv manifest-tool-linux-amd64 $(MANIFEST_TOOL)
endif
	chmod +x $(MANIFEST_TOOL)
endif

clean:
	rm -f $(MANIFEST_TOOL)
