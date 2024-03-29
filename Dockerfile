FROM rocker/geospatial
#FROM rocker/verse
LABEL maintainer="Anders Kiledal <akiledal@udel.edu>"

# Install the geospatial packages here, rather than relying on the pre-built geospatial release
# Used selectively when the rocker/geospatial builds are old
#RUN /bin/sh -c /rocker_scripts/install_geospatial.sh # buildkit

# To enable remote file access
RUN sudo apt update && sudo apt install -y fuse rclone python3-pip

# For read processing
RUN python3 -m pip install --user --upgrade cutadapt

# Install oligoarray for DECIPHER R package (needed for PCR primer design)
RUN wget http://www.unafold.org/download/oligoarrayaux-3.8.tar.gz && \
    tar xzf oligoarrayaux-3.8.tar.gz && \
    cd oligoarrayaux-3.8 && \
    ./configure && \
    make && \
    sudo make install

# Install other R libraries
RUN install2.r --error \
        here vegan patchwork ggrepel foreach BiocManager DiagrammeR ggbeeswarm corrr ggdendro \
        igraph Matrix data.table VennDiagram eulerr UpSetR Cairo ragg glue ggtext furrr \
        pheatmap forcats vroom future.apply indicspecies permute xlsx magick usedist janitor \
        lubridate scales ggpubr lme4 lmerTest MuMIn gridExtra gtable ggalluvial gdata TreeDist \
        mgcv reshape2 viridis ggridges ggforce ggmap maps tigris plotly concaveman heatmaply arrow \
        languageserver phytools ape unglue reticulate tidymodels PMA MonoPhy ggnewscale umap \
        gganimate av gifski transformr qs ranger dbscan fpc POMS vip RPostgreSQL kableExtra ggprism \
        openssl picante geomtextpath randomcoloR bio3d RcppAlgos

        # httpgd being installed via GitHub temporarily because it was temporarily removed from CRAN

RUN R -e 'BiocManager::install(c("phyloseq","dada2","ShortRead","Biostrings", \
        "microbiome", "metagenomeSeq", "decontam", "limma", "biomformat", "ALDEx2", "DESeq2", "ggtree", \
        "KEGGgraph","org.Hs.eg.db", "KEGGREST", "AnnotationDbi", "pcaMethods", "DECIPHER", "ANCOMBC", "fgsea", "topGO", "ANCOMBC", "gage","clusterProfiler"))'
        
RUN R -e 'devtools::install_github("mikemc/speedyseq"); \
        devtools::install_github("tpq/propr"); \
        devtools::install_github("zdk123/SpiecEasi"); \
        devtools::install_github("jbisanz/qiime2R"); \
        devtools::install_github("fbreitwieser/pavian"); \
        devtools::install_github("grunwaldlab/metacoder"); \
        devtools::install_github("vmikk/metagMisc"); \
        devtools::install_github("stevenpawley/colino"); \
        devtools::install_github("nx10/httpgd")'

#devtools::install_github("d-mcgrath/MetaPathPredict/MetaPredict") # Seems like this was converted to a python project?
#devtools::install_github("https://github.com/eqkuiper/ANCOMBC", ref="RELEASE_3_16", quiet = FALSE); \

# If you want to just add a package or two to a recently built image, much faster to add them as new layers here before migrating into the main step
#RUN install2.r --error 