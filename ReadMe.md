# Docker for microbiome analysis

## About
This is my docker container for analyzing 16S data. I primarily made it to manage R packages and use them consistently on different machines.

The Dockerfile is based on the Rocker/verse container to handle the basics of installing R, Rstudio, tidyverse, etc. 

The Dockerfile is pretty interpretable in terms of what packages are installed. Over time I may add packages, but packages likely won't be removed unless there is a compelling reason.

## Usage
This container can be accessed from [DockerHub](https://hub.docker.com/r/eandersk/r_microbiome).

It can be run on BIOMIX using the `rocker.slurm` script included in this directory. Other users will have to modify the `SINGULARITY_BIND` argument of the script, as the version here includes a few user specific mounts for shared storage and work directories. You may also want to change the resources & time requested from SLURM. This script requires singularity (HPC-focused docker alternative) that can be installed with [conda](https://anaconda.org/conda-forge/singularity). When run (`sbatch rocker.slurm`), a file (`rstudio-server.job.{JOBID}`) is created in the home directory with usage/connection instructions.

Snakemake workflows built with this image in mind can be run with the `--use-singularity` flag.

## Why docker?
I manage most other bioinformatics tools with Conda, but that gets pretty messy with R & R-package installations.

I primarily intend this to be used interactively (locally & on BIOMIX, the University of Delaware HPC) through RStudio. However, I also use it in Snakemake pipelines to handle any rules that use R.

## Building instructions (typical)
To build: `docker build -t eandersk/r_microbiome .`
To push : `docker push eandersk/r_microbiome`

## Building instructions on apple silicon, for amd64
Rstudio does not yet run natively on arm64.
Build and push: `docker buildx build --platform linux/amd64 --push -t eandersk/r_microbiome .`