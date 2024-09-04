#! /bin/zsh

docker buildx build --pull --platform linux/amd64 --push -t eandersk/r_microbiome .