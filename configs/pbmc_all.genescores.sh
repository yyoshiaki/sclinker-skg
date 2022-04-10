BASEDIR=~/yyoshiaki-git/sclinker-skg

NAME=exmaple.pbmc.genescores.all
WORKDIR=$BASEDIR/$NAME
GENE_SCORES=$BASEDIR/example.pbmc.all/celltype_genescores.csv
# 0 for all genes, >=1 to select top n gene for each celltype
N_TOP_GENE=0
TISSUE=BLD # BLD, BRN