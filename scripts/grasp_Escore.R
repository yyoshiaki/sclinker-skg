library(data.table)
library(rmeta)

traits = c("UKB_460K.disease_AID_SURE", "PASS_Ulcerative_Colitis", "PASS_Crohns_Disease",
                      "PASS_Rheumatoid_Arthritis", "PASS_Celiac",  "PASS_Lupus", "PASS_Type_1_Diabetes",
                      "PASS_IBD", "PASS_Primary_biliary_cirrhosis")


annot_cell = "/n/groups/price/kushal/Mouse_Humans/data/ANNOTATIONS/GENE_SCORES2/TRANS_BINARY"
