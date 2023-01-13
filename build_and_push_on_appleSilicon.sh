#! /bin/zsh

docker buildx build --platform linux/amd64 --push -t eandersk/r_microbiome .