# Docker for microbiome analysis

## About

This Docker container is built to manage R packages for 'omics analysis, facilitating reproducible use across varied compute environments.

The Dockerfile is based on the [Rocker/geospatial](https://rocker-project.org/images/) which includes R, Rstudio server, and a variety of useful packages such as the tidyverse and geospatial analysis packages.

The Dockerfile is pretty interpretable in terms of what packages are installed. Over time packages may be added, but packages likely won't be removed unless there is a compelling reason.

## Usage

This container can be accessed from [DockerHub](https://hub.docker.com/r/eandersk/r_microbiome).

It can be run on HPCs wth SLURM using the `rocker.slurm` script included in this directory. Other users will have to modify the `SINGULARITY_BIND` argument of the script, as the version here includes a few user specific mounts for shared storage and work directories. You may also want to change the resources & time requested from SLURM. This script requires singularity (HPC-focused docker alternative) that can be installed with [conda](https://anaconda.org/conda-forge/singularity). When run (`sbatch rocker.slurm`), a file (`rstudio-server.job.{JOBID}`) is created in the home directory with usage instructions and instructions for connecting to the rstudio server.

Snakemake workflows built with this image in mind can be run with the `--use-singularity` flag.

## Why docker?

I manage most other bioinformatics tools with Conda, but that gets pretty messy with R & R-package installations.

I primarily intend this to be used interactively (locally & on university HPCs) through RStudio server. However, I also use it in Snakemake pipelines to handle any rules that rely on R.

## Building instructions (typical)

To build: `docker build -t eandersk/r_microbiome .`
To push : `docker push eandersk/r_microbiome`

## Building instructions on apple silicon, for amd64

You can build x86 containers on a mac with apple silicon.
To build on a newer mac and push to docker hub: `./build_and_push_on_appleSilicon.sh`
