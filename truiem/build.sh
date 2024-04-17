#!/bin/zsh

SHA_SHORT=$(git rev-parse --short HEAD)

podman build . --platform linux/amd64 -t ghcr.io/gulfcoastdevops/spilo:${SHA_SHORT}
podman tag ghcr.io/gulfcoastdevops/spilo:${SHA_SHORT} 656688821056.dkr.ecr.us-east-1.amazonaws.com/spilo:${SHA_SHORT}
podman push ghcr.io/gulfcoastdevops/spilo:${SHA_SHORT}
podman push 656688821056.dkr.ecr.us-east-1.amazonaws.com/spilo:${SHA_SHORT}
