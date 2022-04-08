## Edited by Dr. Y. Takeshima, Y. Yasumizu, base : https://github.com/kkdey/GSSG/tree/master/code/GeneSet_toS2G
## 2022/03/31
## only for Blood or Brain

suppressMessages(library(tidyverse))
suppressMessages(library(data.table))
options(stringsAsFactors=F)

###########
# setwd("~/media32TB/bioinformatics/autoimmune_10x/sclinker/example/pbmc")
# file_name = "gene_scores/CD14Monocyte.txt"
# name_tmp    = "tmp"
# OUTPUT_BED  = "test_bed"
# dir_gssgdata = "~/media32TB/bioinformatics/autoimmune_10x/sclinker/data/GSSG"

# /usr/bin/Rscript ../../scripts/geneset_to_bed_roadmap_u_ABC.R gene_scores/CD14Monocyte.txt test_bed ~/media32TB/bioinformatics/autoimmune_10x/sclinker/data/GSSG

########## Roadmap_U_ABC ##########
########## 該当する遺伝子に対して、①Roadmapで定義されたenhancer領域(今回はbloodに限定), ② ABC(ChIP * HiC)で定義したpeak region のunionのbedを抽出

##########

args <- commandArgs(trailingOnly = T)

# ファイル名、パラメタを設定
file_name <- args[1]
OUTPUT_BED <- args[2]
dir_gssgdata <- args[3]
tissue <- args[4]

# 設定内容を出力
message(paste("file_name = ", file_name, sep=""))
message(paste("output_bed = ", OUTPUT_BED, sep=""))

gene_scores = read.table(file_name,header=F,col.names=c("Gene", "scale_score"),row.names=NULL,stringsAsFactors=F)

ABC_Road_bedgraph_calc <- function(gene_scores,
                                   tissuename,  ## "BLD" / "BRN"
                                   output_bed = "temp.bed"){
                           
                             df_pre = fread(paste0(dir_gssgdata, "/data_extra/AllPredictions.AvgHiC.ABC0.015.minus150.withcolnames.ForABCPaper.txt.gz")) %>%
                                       data.frame() %>%
                                       dplyr::filter(class %in% c("intergenic","genic"))  #### omit "promoter"
                             if(tissuename == "BRN"){
                                tissuenames2 = c("neur", "Neur", "astro", "spinal", "Brain", "brain")
                               }       
                             if(tissuename == "BLD"){
                                 tissuenames2 = read.table(paste0(dir_gssgdata, "/processed_data/ABC.listbloodQC.txt"), header=F) %>% pull(V1) %>% as.character()
                               }
                           
                             final_bed1  = df_pre %>% 
                                             dplyr::filter(CellType %in% tissuenames2) %>%
                                             dplyr::select(c("chr", "start", "end", "TargetGene")) %>%
                                             left_join(.,gene_scores,by=c("TargetGene"="Gene") ) %>%
                                             mutate(scale_score = ifelse(is.na(scale_score),"0",scale_score) ) %>%
                                             dplyr::select(c("chr", "start", "end", "scale_score") )
                           
                             roadmap_meta = read.delim(paste0(dir_gssgdata, "/processed_data/Roadmap_map_EID_names.txt"),header=F)
                             Road_ids     = roadmap_meta %>%
                                             dplyr::filter( grepl(tissuename,roadmap_meta$V2) ) %>%
                                             pull(V1) %>% unique()
                             roadmap_meta %>%
                              dplyr::filter( grepl(tissuename,roadmap_meta$V2) ) %>%
                              pull(V3) %>% print()
                           
                             Enhancer = c()
                             for(ee in Road_ids){
                               temp_1 = read.table(paste0(dir_gssgdata, "/processed_data/RoadmapLinks/","links_", ee, "_7_2.5.txt"))
                               temp_2 = read.table(paste0(dir_gssgdata, "/processed_data/RoadmapLinks/","links_", ee, "_6_2.5.txt"))
                               Enhancer = rbind(Enhancer, temp_1[,1:4], temp_2[,1:4])
                               cat("We processed file:", ee, "\n")
                             }
                           
                             geneanno = read.csv(paste0(dir_gssgdata, "/processed_data/gene_anno_unique_datefix.txt"), sep = "\t")
                           
                             final_bed2 = left_join(Enhancer,geneanno,by=c("V4"="id")) %>%
                                           left_join(.,gene_scores,by=c("symbol"="Gene")) %>%
                                           mutate(scale_score = ifelse(is.na(scale_score),"0",scale_score) ) %>%
                                           dplyr::select(c("V1", "V2", "V3", "scale_score") ) %>%
                                           dplyr::rename(chr = 1 , start = 2 , end = 3)
                           
                             final_bed = rbind(final_bed1, final_bed2)
                           
                             dirname(output_bed) %>% dir.create(., showWarnings = FALSE, recursive = TRUE)
                             write.table(final_bed, paste0(output_bed),
                                         sep = "\t", quote=FALSE, row.names=FALSE, col.names=FALSE)
                           }

##########
ABC_Road_bedgraph_calc(gene_scores, tissue, output_bed = OUTPUT_BED )