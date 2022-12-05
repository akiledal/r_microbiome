FROM rocker/geospatial
LABEL maintainer="Anders Kiledal <akiledal@udel.edu>"

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
        httpgd languageserver phytools ape

RUN R -e 'BiocManager::install(c("phyloseq","dada2","ShortRead","Biostrings", \
        "microbiome", "metagenomeSeq", "decontam", "limma", "biomformat", "ALDEx2", "DESeq2", "ggtree", \
        "KEGGgraph","org.Hs.eg.db", "KEGGREST", "AnnotationDbi", "pcaMethods", "DECIPHER"))'
        
RUN R -e 'devtools::install_github("mikemc/speedyseq"); \
        devtools::install_github("tpq/propr"); \
        devtools::install_github("zdk123/SpiecEasi"); \
        devtools::install_github("jbisanz/qiime2R"); \
        devtools::install_github("fbreitwieser/pavian"); \
        devtools::install_github("grunwaldlab/metacoder"); \
        devtools::install_github("vmikk/metagMisc")'
    #&& install2.r --error pathfindR
