library(tidyverse)

args <- commandArgs(trailingOnly = T)

# workdir <- args[1]
f_traits <- args[1]
f_annot <- args[2]
base_her <- args[3]
dir_img <- args[4]

# f_traits <- '/home/yyasumizu/media32TB/bioinformatics/autoimmune_10x/sclinker/data/ldsc/sumstats.csv'
# f_annot <- './gene_scores/categories.txt'
# base_her <- 'heritability/Roadmap_U_ABC_h2'
# dir_img <- 'img'
suffix <- '_merged'


# setwd('/home/yyasumizu/media32TB/bioinformatics/autoimmune_10x/sclinker/exmaple.pbmc.all')

df.traits <- read.csv(f_traits)

df.traits <- df.traits %>% 
    mutate(Name = str_replace(df.traits$File, '.sumstats', ''))

df.annot <- read.csv(f_annot, header=FALSE, col.names=c("Annotations"))

for (i in 1:nrow(df.traits)) {
    f <- paste(base_her, '/', df.traits[i,'Name'], suffix, '.results', sep='')
    d <- read.table(f, header=TRUE) 
    d <- d %>% mutate(Annotations = str_replace(d$Category, "L2_0", "")) %>%
        filter(Annotations %in% df.annot$Annotations)
    d['Escore'] <- (d$Enrichment - d[d$Annotations=='ALL', 'Enrichment'])
    d <- d %>% mutate(Escore = if_else(Escore < 0, 0, Escore)) %>%
        rename(pEscore = Enrichment_p) %>%
        select(c('Annotations', 'Escore', 'pEscore')) %>%
        filter(Annotations != "ALL")
    d['Trait'] <- df.traits[i,'Name']

    if (i == 1){
        df <- d
    } else {
       df <- rbind(df, d)
    }
 }

df <- df %>% left_join(df.traits, by=c("Trait" = "Name")) %>% 
    mutate(pEscore = if_else(Escore == 0, 1, pEscore))
df['qEscore'] <- p.adjust(df$pEscore, method = "BH", n = length(df$pEscore))
df['-log10(qEscore)'] <- -log10(df$qEscore)

####### Autoimmune
df.plot <- df %>% filter(Autoimmune == 1)

ggplot(df.plot, aes(Annotations, Trait, colour = -log10(qEscore), size = Escore)) +
  geom_point() +
  scale_color_gradient(low="white", high="red") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
ggsave(paste0(dir_img, '/AID.pdf'), width = 8, height = 5)

####### Blood
df.plot <- df %>% filter(Blood == 1)

ggplot(df.plot, aes(Annotations, Trait, colour = -log10(qEscore), size = Escore)) +
  geom_point() +
  scale_color_gradient(low="white", high="red") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
ggsave(paste0(dir_img, '/Blood.pdf'), width = 8, height = 5)

####### Neurodegenerative
df.plot <- df %>% filter(Neurodegenerative == 1)

ggplot(df.plot, aes(Annotations, Trait, colour = -log10(qEscore), size = Escore)) +
  geom_point() +
  scale_color_gradient(low="white", high="red") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
ggsave(paste0(dir_img, '/Neurodegenerative.pdf'), width = 8, height = 5)

####### All
df.plot <- df

ggplot(df.plot, aes(Annotations, Trait, colour = -log10(qEscore), size = Escore)) +
  geom_point() +
  scale_color_gradient(low="white", high="red") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
ggsave(paste0(dir_img, '/All.pdf'), width = 8, height = 40)

