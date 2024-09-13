#!/usr/bin/env python3
import sys
import pandas as pd

def check(list):
    return all(i == list[0] for i in list)


for i in range(len(sys.argv)):
    if sys.argv[i] == "-distmat":
        dirdistmat = sys.argv[i+1]
    elif sys.argv[i] == "-refsIds":
        idsrefs = sys.argv[i+1]

ids_refs = pd.read_csv(idsrefs, sep=";")
refs = ids_refs["id"].to_list()
refs.append('ids')

distmat = pd.read_csv(dirdistmat, sep=",")
distmat = distmat.drop(labels='Unnamed: 0', axis=1)
ids = list(distmat.columns)
distmat['ids'] = ids
distmat_sel = distmat.loc[:, distmat.columns.isin(refs)]

ids_refs = ids_refs[ids_refs['id'].isin(distmat_sel.columns[:-1].tolist())]
refs = ids_refs["id"].to_list()

# Get segment
segment = dirdistmat.split('_')[0]

distmat_sel = distmat_sel[~distmat_sel['ids'].isin(refs)]

gentoypes = []
for l in list(distmat_sel.columns):
    print(l)
    if l != "ids":
        print(ids_refs.loc[ids_refs['id'] == l, 'genotype'].item())
        g = ids_refs.loc[ids_refs['id'] == l, 'genotype'].item()
        gentoypes.append(g)
    else:
        gentoypes.append("ids")
distmat_sel.columns = gentoypes

segment_genotypes = []
segment_name = []
# Get the list of the lower value by each row
minDist = distmat_sel.min(axis=1).to_list()
count = 0
# Get the column names that match the lower value of that row (minDist[index])
for index, row in distmat_sel.iterrows():
    columns_with_value = row.index[row == minDist[count]].tolist()
    count += 1
    # If just one column with lower value, keep the name. Else, get a string with all the names
    if len(columns_with_value) == 1:
        segment_genotypes.append(columns_with_value[0])
        segment_name.append(segment)
    else:
        if check(columns_with_value): # If all genotypes are equal
            segment_genotypes.append(columns_with_value[0])
            segment_name.append(segment)
        else:
            columns_with_value = sorted(list(dict.fromkeys(columns_with_value)))
            m = ','.join(columns_with_value)
            segment_genotypes.append(m)
            segment_name.append(segment)

dictout = {'segment': segment_name, 'ids': distmat_sel["ids"].to_list(), 'genotype': segment_genotypes}
df = pd.DataFrame(dictout)

df.to_csv(dirdistmat.split('.')[0]+"_genotype.csv", index=False)
