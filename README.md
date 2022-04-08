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
bash scripts/prep_data.sh
```

2. create env for ldsc

```
cd ldsc
onda env create --file environment.yml
```

## Run sclinker-celltype

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