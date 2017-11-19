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


all: get-manifest-tool
	@# Darwin
	echo $(PLATFORM)
ifeq ($(PLATFORM),Darwin)
	# amd64
	docker build -t yen3/docker-ubuntu-novnc:amd64 .
	docker push yen3/docker-ubuntu-novnc:amd64
	# arm64v8
	docker build -t yen3/docker-ubuntu-novnc:arm64 -f Dockerfile_arm64v8 .
	docker push yen3/docker-ubuntu-novnc:arm64
	# arm32v7
	docker build -t yen3/docker-ubuntu-novnc:arm32v7 -f Dockerfile_arm32v7 .
	docker push yen3/docker-ubuntu-novnc:arm32v7
	# Create the multi-arch docker image
ifneq ($(MACOS),)
	$(MANIFEST_TOOL) $(MACOS) push from-spec ./manifest.yml
endif

else
	@# Linux
	@# Register binfmt
	docker run --privileged yen3/binfmt-register set arm
	docker run --privileged yen3/binfmt-register set aarch64

	@# Get qemu binary
	docker run yen3/binfmt-register get arm > qemu-arm-static
	docker run yen3/binfmt-register get aarch64 > qemu-aarch64-static

	@# build docker image
	@# amd64
	docker build -t yen3/docker-ubuntu-novnc:amd64 .
	docker push yen3/docker-ubuntu-novnc:amd64
	@# arm64v8
	docker build -t yen3/docker-ubuntu-novnc:arm64 -f Dockerfile_arm64v8 .
	docker push yen3/docker-ubuntu-novnc:arm64
	@# arm32v7
	docker build -t yen3/docker-ubuntu-novnc:arm32v7 -f Dockerfile_arm32v7 .
	docker push yen3/docker-ubuntu-novnc:arm32v7

	@# Create the multi-arch docker image
	$(MANIFEST_TOOL) $(MACOS) push from-spec ./manifest.yml
	
	@# Clear binfmt
	docker run --privileged yen3/binfmt-register clear arm
	docker run --privileged yen3/binfmt-register clear aarch64
endif

get-manifest-tool:
ifeq ($(PLATFORM),Darwin)
	@# Darwin
	curl -s https://github.com/estesp/manifest-tool/releases/download/v0.7.0/manifest-tool-darwin-amd64 > $(MANIFEST_TOOL)
else
	@# Linux
	curl -s https://github.com/estesp/manifest-tool/releases/download/v0.7.0/manifest-tool-linux-amd64 > $(MANIFEST_TOOL)
endif

clear:
	rm -f qemu-arm-static
	rm -f qemu-aarch64-static
	rm -f $(MANIFEST_TOOL)
