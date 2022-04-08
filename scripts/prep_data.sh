#!/bin/bash
set -xe

WORKDIR=~/media32TB/bioinformatics/autoimmune_10x/sclinker


cd $WORKDIR
# git clone scgenetics and GSSG
git clone https://github.com/karthikj89/scgenetics.git
git clone https://github.com/kkdey/GSSG.git
# git clone https://github.com/bulik/ldsc.git
git clone https://github.com/yyoshiaki/ldsc.git

# install LDSC
cd ldsc
conda env create --file environment.yml
cd ..

# download annotations for G2S
mkdir data
cd data
wget https://alkesgroup.broadinstitute.org/LDSCORE/Dey_Enhancer_MasterReg/processed_data/
mkdir GSSG
cd GSSG

mkdir processed_data
cd processed_data
wget https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/Dey_Enhancer_MasterReg/processed_data/ABC.listbloodQC.txt
wget https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/Dey_Enhancer_MasterReg/processed_data/Roadmap_map_EID_names.txt
wget https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/Dey_Enhancer_MasterReg/processed_data/gene_anno_unique_datefix.txt
cd ..

mkdir data_extra
cd data_extra
wget https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/DeepLearning/Dey_DeepBoost_Imperio/data_extra/AllPredictions.AvgHiC.ABC0.015.minus150.withcolnames.ForABCPaper.txt.gz
cd ..

cd processed_data
wget https://ernstlab.biolchem.ucla.edu/roadmaplinking/RoadmapLinks.zip
unzip RoadmapLinks.zip
cd ../..

mkdir ldsc
cd ldsc
wget https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/1000G_Phase3_baselineLD_v2.1_ldscores.tgz
tar xvf 1000G_Phase3_baselineLD_v2.1_ldscores.tgz

wget https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/1000G_Phase3_frq.tgz
tar xvf 1000G_Phase3_frq.tgz 

wget https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/1000G_Phase3_weights_hm3_no_MHC.tgz
tar xvf 1000G_Phase3_weights_hm3_no_MHC.tgz

wget https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/1000G_Phase3_plinkfiles.tgz
tar xvf 1000G_Phase3_plinkfiles.tgz

wget https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/hapmap3_snps.tgz
tar xvf hapmap3_snps.tgz

# https://github.com/bulik/ldsc/wiki/Partitioned-Heritability-from-Continuous-Annotations
wget https://data.broadinstitute.org/alkesgroup/LDSCORE/w_hm3.snplist.bz2
bunzip2 w_hm3.snplist.bz2
awk '{if ($1!="SNP") {print $1} }' w_hm3.snplist > listHM3.txt

gsutil cp -r gs://broad-alkesgroup-public/LDSCORE/all_sumstats .