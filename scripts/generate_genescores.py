#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: yyasumizu
# @Date: 2023-03-30
# @Last Modified time: 2023-04-07

'''
usage : 
python generate_genescores.py <input_genescores.csv> <outdir> <top_n_gene>

top_n_gene : 0 means all genes, >=1 means retain gene scores of only top n genes.
'''

import sys
import os
import pandas as pd
import matplotlib.pyplot as plt

f_input = sys.argv[1]
dir_out = sys.argv[2]
n_gene = int(sys.argv[3])

os.makedirs(dir_out + '/img', exist_ok=True)
df_gs = pd.read_csv(f_input, index_col=0)
df_gs['ALL'] = 1

list_c = []
for c in list(df_gs.columns):
    # print(''.join(filter(str.isalnum, c)))
    fid = ''.join(filter(str.isalnum, c))
    list_c.append(fid)
    if (n_gene > 0) & (c != "ALL"):
        df_gs.loc[df_gs[c].rank(ascending=False, method='min') > n_gene, c] = 0
    df_gs[c].to_csv('{}/{}.txt'.format(dir_out, fid), sep='\t', header=None)

pd.DataFrame([list_c]).T.to_csv('{}/categories.txt'.format(dir_out), header=None, index=None)

plt.figure(figsize=(10,10))
for i in range(df_gs.shape[1]):
    plt.subplot(5,int(df_gs.shape[1]/5)+1,i+1)
    df_gs.iloc[:,i].hist(bins=100)
    plt.yscale('log')
    plt.title(df_gs.columns[i])
plt.tight_layout()
plt.savefig('{}/img/hist.pdf'.format(dir_out), bbox_inches='tight')