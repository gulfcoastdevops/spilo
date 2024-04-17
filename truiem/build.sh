SHA_SHORT=$(git rev-parse --short HEAD)

docker build . --platform linux/amd64 -t ghcr.io/gulfcoastdevops/spilo:${SHA_SHORT}
docker tag ghcr.io/gulfcoastdevops/spilo:${SHA_SHORT} 656688821056.dkr.ecr.us-east-1.amazonaws.com/spilo:${SHA_SHORT}
docker push ghcr.io/gulfcoastdevops/spilo:${SHA_SHORT}
docker push 656688821056.dkr.ecr.us-east-1.amazonaws.com/spilo:${SHA_SHORT}
