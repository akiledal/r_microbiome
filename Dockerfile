FROM rocker/geospatial
LABEL maintainer="Anders Kiledal <akiledal@udel.edu>"

# Install other libraries
RUN install2.r --error \
        here vegan patchwork ggrepel foreach BiocManager DiagrammeR ggbeeswarm corrr \
        igraph Matrix data.table VennDiagram eulerr UpSetR Cairo ragg glue ggtext furrr \
        pheatmap forcats vroom future.apply indicspecies permute xlsx magick usedist \
        lubridate scales ggpubr lme4 lmerTest MuMIn gridExtra gtable ggalluvial gdata TreeDist \
        mgcv reshape2 viridis ggridges ggforce ggmap maps tigris plotly concaveman heatmaply \
    && R -e 'BiocManager::install(c("phyloseq","dada2","ShortRead","Biostrings", \
        "microbiome", "metagenomeSeq", "decontam", "limma", "biomformat", "ALDEx2", "DESeq2", "ggtree", \
        "KEGGgraph","org.Hs.eg.db", "KEGGREST", "AnnotationDbi", "pcaMethods", "DECIPHER")); \
        devtools::install_github("mikemc/speedyseq"); \
        devtools::install_github("tpq/propr"); \
        devtools::install_github("zdk123/SpiecEasi"); \
        devtools::install_github("jbisanz/qiime2R"); \
        devtools::install_github("fbreitwieser/pavian"); \
        devtools::install_github("grunwaldlab/metacoder"); \
        devtools::install_github("vmikk/metagMisc")' \
    && install2.r --error pathfindR
