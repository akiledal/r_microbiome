FROM rocker/geospatial
LABEL maintainer="Anders Kiledal <akiledal@udel.edu>"

# Install other libraries
RUN install2.r --error \
        here vegan patchwork ggrepel foreach BiocManager metacoder DiagrammeR \
        igraph Matrix data.table VennDiagram eulerr UpSetR Cairo ragg glue ggtext \
        pheatmap forcats vroom future.apply indicspecies permute xlsx magick usedist \
        lubridate scales ggpubr lme4 lmerTest MuMIn gridExtra gtable ggalluvial gdata \
        mgcv reshape2 viridis ggridges ggforce ggmap maps tigris plotly concaveman\
    && R -e 'BiocManager::install(c("phyloseq","dada2","ShortRead","Biostrings", \
        "microbiome", "metagenomeSeq", "decontam", "limma", "biomformat", "ALDEx2", "DESeq2", "ggtree", \
        "KEGGgraph","org.Hs.eg.db", "KEGGREST", "AnnotationDbi")); \
        devtools::install_github("mikemc/speedyseq"); \
        devtools::install_github("tpq/propr"); \
        devtools::install_github("zdk123/SpiecEasi"); \
        devtools::install_github("akiledal/qiime2R", ref = "patch-2"); \
        devtools::install_github("vmikk/metagMisc")' \
    && install2.r --error pathfindR