#!/bin/bash
set -xe

# example : bash ./scripts/sclinker-workflow.celltype.skg.sh configs/pbmc_all.sh 

source $1

mkdir -p $WORKDIR
cd $WORKDIR

mkdir -p img

eval "$(conda shell.bash hook)"
conda activate scanpy1.8.1

# 1. generateGenePrograms.py celltype adata outdir prefix,sample_col,celltype_col 
python $BASEDIR/scgenetics/src/generateGenePrograms.py celltype $ADATA ./ celltype,sample_id,${CELLTYPE_COL}

conda activate base

# 2. make genescore files for each celltype
python $BASEDIR/scripts/generate_genescores.py celltype_genescores.csv gene_scores $N_TOP_GENE ./img

# 3. calc ABC
bash $BASEDIR/scripts/geneset_to_bed_roadmap_u_ABC.sh gene_scores $BASEDIR/data/GSSG $TISSUE

# 4. cleanbed 
mkdir -p cleaned_bed/Roadmap_U_ABC
bash $BASEDIR/scripts/clean_bed.sh bed/Roadmap_U_ABC cleaned_bed/Roadmap_U_ABC

conda activate ldsc
# 5. make annot
mkdir -p annotations/Roadmap_U_ABC
for CELL in `cat gene_scores/categories.txt`;do
 python ${BASEDIR}/scripts/bedgraph_to_annot.py \
  --bedname ${CELL} --bedfile_path ./cleaned_bed/Roadmap_U_ABC/ \
  --bimfile_path ${BASEDIR}/data/ldsc/1000G_EUR_Phase3_plink \
  --annot_path annotations/Roadmap_U_ABC
done

conda activate base
# 6. merge annot
python ${BASEDIR}/scripts/merge_annot.py ./annotations/Roadmap_U_ABC ./gene_scores/categories.txt ./annotations/Roadmap_U_ABC/merged.

conda activate ldsc
mkdir -p ldsc/Roadmap_U_ABC

# 7. calc ldscore
DIR_REF=$BASEDIR/data/ldsc

seq 1 22 | xargs -P22 -I@ bash -c "python ${BASEDIR}/ldsc/ldsc.py --l2 --bfile ${DIR_REF}/1000G_EUR_Phase3_plink/1000G.EUR.QC.@ --ld-wind-cm 1 --yes-really --print-snps ${DIR_REF}/listHM3.txt --annot ./annotations/Roadmap_U_ABC/merged.@.annot.gz --out ./annotations/Roadmap_U_ABC/merged.@"


# 8. calc partitioned heritability
mkdir -p heritability/Roadmap_U_ABC_h2

for TRAIT in $(ls ${DIR_REF}/all_sumstats | grep .sumstats | sed "s/.sumstats//g");do
echo ${TRAIT}
python ${BASEDIR}/ldsc/ldsc.py \
 --h2 ${DIR_REF}/all_sumstats/${TRAIT}.sumstats \
 --ref-ld-chr annotations/Roadmap_U_ABC/merged.,${DIR_REF}/1000G_Phase3_baselineLD_v2.1_ldscores/baselineLD. \
 --frqfile-chr ${DIR_REF}/1000G_Phase3_frq/1000G.EUR.QC. \
 --w-ld-chr ${DIR_REF}/1000G_Phase3_weights_hm3_no_MHC/weights.hm3_noMHC. \
 --overlap-annot --print-coefficients --print-delete-vals \
 --out heritability/Roadmap_U_ABC_h2/${TRAIT}_merged
done

conda activate base

# 9. visualize
Rscript ${BASEDIR}/scripts/visualize_Escore.R \
    ${CSV_SUMSTATS} \
    ./gene_scores/categories.txt \
    ./heritability/Roadmap_U_ABC_h2 \
    ./img
