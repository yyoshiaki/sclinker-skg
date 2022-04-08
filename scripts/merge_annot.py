#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: yyasumizu
# @Date: 2022-04-03
# @Last Modified time: 2022-04-05

'''
usage : 
python merge_annot.py <input dir> <input categories> <output prefix>

example
python merge_annot.py ./annotations/Roadmap_U_ABC ./gene_scores/categories.txt ./annotations/Roadmap_U_ABC/merged.
'''

import sys
import glob
import pandas as pd

dir = sys.argv[1]
f_cat = sys.argv[2]
prefix = sys.argv[3]

list_cat = list(pd.read_csv(f_cat, header=None)[0]) 

print('Categories :')
print(list_cat)

# list_annot = glob.glob(dir+'/*annot*')
# list_annot = ['{}/{}.annot.gz'.format(dir, c) for c in list_cat]

# process only 1 to 22
for i in range(1,23):
    print('chrom : ', i)

    f_out = "{}{}.annot.gz".format(prefix, str(i)) 
    # l_annot = [f for f in list_annot if '.{}.annot'.format(str(i)) in f]
    l_annot = ['{}/{}.{}.annot.gz'.format(dir, c, str(i)) for c in list_cat]

    for j,f in enumerate(l_annot):
        if j == 0:
            df = pd.read_csv(f, sep='\t')
        else:
            d = pd.read_csv(f, sep='\t')
            df = pd.merge(df,d, on=['CHR', 'BP', 'SNP', 'CM'])

    df.to_csv(f_out, sep='\t', index=False)