# sclinker-skg

## Setup

0. Prerequisite

- gsutil
- conda
- scanpy (in python3)
- bedtools
- R (calling /usr/bin/Rscript in the script.)
- tidyverse (in R)

1. Download data

```
git clone https://github.com/yyoshiaki/sclinker-skg.git
cd sclinker-skg
bash scripts/prep_data.sh ${PWD}
```

2. create env for ldsc

```
cd ldsc
conda env create --file environment.yml
conda create --name scanpy1.8.1 python=3.8 scanpy=1.8.1
```

## sclinker-celltype

This includes scanpy's `scanpy.tl.rank_genes_group`.

Usage

```
bash ./scripts/sclinker-workflow.celltype.skg.sh ./configs/pbmc_all.sh
```


## Example (PBMC)

```
mkdir -p example
cd example
# download scanpy object
wget https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/Jagadeesh_Dey_sclinker/scdata/pbmc-processed-annotated.h5ad
cd ..

bash ./scripts/sclinker-workflow.celltype.skg.sh ./configs/pbmc_all.sh
```

### input

```
BASEDIR=~/yyoshiaki-git/sclinker-skg

NAME=exmaple.pbmc.all
CELLTYPE_COL=celltype
WORKDIR=$BASEDIR/$NAME
ADATA=$BASEDIR/example/pbmc-processed-annotated.h5ad
# 0 for all genes, >=1 to select top n gene for each celltype
N_TOP_GENE=0
TISSUE=BLD # BLD, BRN
```

## sclinker-genescores

This pipline starts from a genescore's CSV file.

```
bash ./scripts/sclinker-workflow.genescores.skg.sh ./configs/pbmc_all.genescores.sh
```

## Example (PBMC, after execution of celltype mode)

```
bash ./scripts/sclinker-workflow.genescores.skg.sh ./configs/pbmc_all.genescores.sh
```

### input

```
BASEDIR=~/yyoshiaki-git/sclinker-skg

NAME=exmaple.pbmc.genescores.all
WORKDIR=$BASEDIR/$NAME
GENE_SCORES=$BASEDIR/example.pbmc.all/celltype_genescores.csv
# 0 for all genes, >=1 to select top n gene for each celltype
N_TOP_GENE=0
TISSUE=BLD # BLD, BRN
```