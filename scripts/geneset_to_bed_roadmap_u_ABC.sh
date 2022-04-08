#!/bin/bash
set -xe

# bash geneset_to_bed_roadmap_u_ABC.sh gene_scores

DIR_gs=$1
DIR_gssgdata=$2
TISSUE=$3
mkdir -p bed/Roadmap_U_ABC

SCRIPT_DIR=$(cd $(dirname $0); pwd)
echo $SCRIPT_DIR

echo ${DIR_gs}
for CELL in `cat gene_scores/categories.txt`;do
  echo ${CELL}
  Rscript $SCRIPT_DIR/geneset_to_bed_roadmap_u_ABC.R gene_scores/${CELL}.txt bed/Roadmap_U_ABC/${CELL}.bed ${DIR_gssgdata} ${TISSUE}
done