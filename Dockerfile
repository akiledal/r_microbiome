FROM rocker/geospatial
#FROM rocker/verse
LABEL maintainer="Anders Kiledal <akiledal@udel.edu>"

# Install the geospatial packages here, rather than relying on the pre-built geospatial release
# Used selectively when the rocker/geospatial builds are old
#RUN /bin/sh -c /rocker_scripts/install_geospatial.sh # buildkit

# To enable remote file access
RUN sudo apt update && sudo apt install -y fuse rclone python3-pip pipx

# For read processing
# --break-system-packages ## needed for certain versions
RUN python3 -m pip install --upgrade cutadapt --break-system-packages 

# For multi-omics stats [https://biofam.github.io/MOFA2/MEFISTO.html]
# --break-system-packages ## needed for certain versions
RUN sudo apt remove -y python3-packaging
RUN python3 -m pip install --upgrade mofapy2 --break-system-packages

# Install oligoarray for DECIPHER R package (needed for PCR primer design)
RUN wget http://www.unafold.org/download/oligoarrayaux-3.8.1.tar.gz && \
    tar xzf oligoarrayaux-3.8.1.tar.gz && \
    cd oligoarrayaux-3.8.1 && \
    ./configure && \
    make && \
    sudo make install

# Install other R libraries
RUN install2.r --error \
        here vegan patchwork ggrepel foreach BiocManager DiagrammeR ggbeeswarm corrr ggdendro \
        igraph Matrix data.table VennDiagram eulerr UpSetR Cairo ragg glue ggtext furrr \
        pheatmap forcats vroom future.apply indicspecies permute xlsx magick usedist janitor \
        lubridate scales lme4 MuMIn gridExtra gtable ggalluvial gdata TreeDist \
        mgcv reshape2 viridis ggridges ggforce ggmap maps plotly heatmaply arrow \
        languageserver phytools ape unglue reticulate tidymodels PMA ggnewscale umap \
        av qs ranger dbscan fpc POMS vip RPostgreSQL kableExtra ggprism \
        openssl picante geomtextpath randomcoloR bio3d RcppAlgos ggh4x scico tidyquant parzer \
        ggpubr gganimate transformr concaveman tigris cooccur lmerTest conflicted legendry geneviewer \
        broom.mixed emmeans micropan circlize tidyquant

# Issues with installing these packages
#RUN install2.r --error 

# MonoPhy no-longer available on CRAN [may be temporary]

RUN R -e 'BiocManager::install(c("phyloseq","dada2","ShortRead","Biostrings", \
        "microbiome", "metagenomeSeq", "decontam", "limma", "biomformat", "ALDEx2", "DESeq2", "ggtree", \
        "KEGGgraph","org.Hs.eg.db", "KEGGREST", "AnnotationDbi", "pcaMethods", "DECIPHER", "ANCOMBC", \
        "fgsea", "topGO", "ANCOMBC", "gage","clusterProfiler", "pathview", "MOFA2", "Rsamtools", "Rsubread", \
        "basilisk"))'
        
RUN R -e 'devtools::install_github("r-rust/gifski"); \
        devtools::install_github("mikemc/speedyseq"); \
        devtools::install_github("tpq/propr"); \
        devtools::install_github("zdk123/SpiecEasi"); \
        devtools::install_github("jbisanz/qiime2R"); \
        devtools::install_github("fbreitwieser/pavian"); \
        devtools::install_github("grunwaldlab/metacoder"); \
        devtools::install_github("vmikk/metagMisc"); \
        devtools::install_github("stevenpawley/colino"); \
        devtools::install_github("r-dbi/odbc"); \
        devtools::install_github("jiabowang/GAPIT", force=TRUE); \
        devtools::install_github("oschwery/MonoPhy", force=TRUE); \
        devtools::install_github("jeffkimbrel/qSIP2"); \
        remotes::install_github("nx10/httpgd"); \
        devtools::install_github("r-rust/gifski")'

ADD . /tmp/repo
WORKDIR /tmp/repo
ENV PATH /opt/conda/bin:${PATH}
ENV LANG C.UTF-8
ENV SHELL /bin/bash
RUN /bin/bash -c "wget https://github.com/sylabs/singularity/releases/download/v4.1.2/singularity-ce_4.1.2-jammy_amd64.deb -O /tmp/singularity.deb && \
    sudo apt install -y wget bzip2 ca-certificates gnupg2 squashfs-tools git /tmp/singularity.deb && \
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    conda create -c conda-forge -n snakemake bioconda::snakemake bioconda::snakemake-minimal --only-deps && \
    conda clean --all -y && \
    source activate snakemake"

RUN sudo apt update && sudo apt install -y chromium-browser

COPY Dockerfile /Dockerfile

#devtools::install_github("d-mcgrath/MetaPathPredict/MetaPredict") # Seems like this was converted to a python project?
#devtools::install_github("https://github.com/eqkuiper/ANCOMBC", ref="RELEASE_3_16", quiet = FALSE); \

# If you want to just add a package or two to a recently built image, much faster to add them as new layers here before migrating into the main step
#RUN install2.r --error 