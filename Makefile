# Manifest tool - Create a multi-arch docker image
# See https://github.com/estesp/manifest-tool to get more deatils
MANIFEST_TOOL=manifest-tool

# manifest tool can not use environment setting to set docker username/password
# You have to set as command argument
# e.g.
#      manifest --username <docker-username> --passsword <docker-password> \
#         push from-spec ./manifest.yml
MACOS=

all:
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
	$(MANIFEST_TOOL) $(MACOS) push from-spec ./manifest.yml
