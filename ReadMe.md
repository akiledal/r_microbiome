# Docker for microbiome (16S)

## About
This is my docker image for analyzing 16S data. I primarily made it to manage R packages and use them consistently on different machines.

The Dockerfile is pretty interpretable in terms of what packages are installed.

The Dockerfile is based on the Rocker/verse images to handle the basics of installing R, Rstudio, tidyverse, etc. 

## Usage
This image can be accessed from [DockerHub](dockerhub.com/eandersk/) and pulled with `docker pull`.

It can be run on BIOMIX using the `rocker.slurm` script included in this directory. This script requires singularity (an HPC-focused docker alternative) that can be installed with conda. When run (`sbatch rocker.slurm`) a file is created in the home directory `rstudio` with usage/connection instructions.

Snakemake workflows built with this image in mind can be run with the `--use-singularity` flag.


## Why docker?
I manage most other bioinformatics tools with Conda, but that gets pretty messy with R & R package installations.

I primarily intend this to be used interactively (locally & on BIOMIX, the University of Delaware HPC) through RStudio. However, I also use it in Snakemake pipelines to handle any rules that use R.