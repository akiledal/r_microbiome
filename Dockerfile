FROM rocker/verse
LABEL maintainer="Anders Kiledal <akiledal@udel.edu>"

# Install other libraries
RUN install2.r --error \
        here vegan patchwork ggrepel foreach BiocManager metacoder DiagrammeR \
        igraph Matrix data.table VennDiagram eulerr UpSetR Cairo ragg glue ggtext \
        pheatmap forcats vroom future.apply indicspecies permute xlsx magick \
        lubridate scales ggpubr lme4 lmerTest MuMIn gridExtra gtable ggalluvial \
        mgcv reshape2 viridis ggridges ggforce ggmap mapdata maps \
    && R -e 'BiocManager::install(c("phyloseq","dada2","ShortRead","Biostrings", \
        "microbiome", "metagenomeSeq", "decontam", "limma", "biomformat", "ALDEx2", "DESeq2", "ggtree")); \
        devtools::install_github("tpq/propr"); \
        devtools::install_github("zdk123/SpiecEasi"); \
        devtools::install_github("jbisanz/qiime2R"); \
        devtools::install_github("vmikk/metagMisc")'