BASEDIR=/home/yyasumizu/yyoshiaki-git/sclinker-skg

NAME=exmaple.pbmc.1000
CELLTYPE_COL=celltype
WORKDIR=$BASEDIR/$NAME
ADATA=$BASEDIR/example/pbmc-processed-annotated.h5ad
# 0 for all genes, >=1 to select top n gene for each celltype
N_TOP_GENE=1000
TISSUE=BLD # BLD, BRN
CSV_SUMSTATS=${BASEDIR}/data/ldsc/sumstats.csv