BASEDIR=~/media32TB/bioinformatics/autoimmune_10x/sclinker

NAME=exmaple.pbmc.500
WORKDIR=$BASEDIR/$NAME
ADATA=$BASEDIR/example/pbmc-processed-annotated.h5ad
# 0 for all genes, >=1 to select top n gene for each celltype
N_TOP_GENE=500
TISSUE=BLD # BLD, BRN
