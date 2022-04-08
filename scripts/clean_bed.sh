#!/bin/bash
set -xe

DIR=$1
OUTDIR=$2

mkdir -p ${DIR}/tmp_bed

for BED_name in $(ls ${DIR} | grep -v tmp_bed);do
#   TMP_NAME=$(echo ${BED_name}|cut -d "_" -f 1,2)
  TMP_NAME=${BED_name}
  echo $BED_name
  bedtools sort -i ${DIR}/${BED_name} > ${DIR}/tmp_bed/tmp_${TMP_NAME}.bed
  ####### 重なった場合は最大値を検出 ## 重なったregionは結合させる(union)
  bedtools merge -i ${DIR}/tmp_bed/tmp_${TMP_NAME}.bed -c 4 -o max > ${OUTDIR}/${BED_name}
  rm ${DIR}/tmp_bed/tmp_${TMP_NAME}.bed
done