#!/usr/bin/env python3
import sys
import pandas as pd


for i in range(len(sys.argv)):
    if sys.argv[i] == "-distmat":
        distmat = sys.argv[i+1]
    elif sys.argv[i] == "-ids":
        id_file = sys.argv[i+1]
    elif sys.argv[i] == "-out":
        out_file = sys.argv[i+1]


def distmat_to_df(distmat):
    count_line = 0
    distances = []
    with open(distmat, 'r') as infile:
        while True:
            line = infile.readline()
            count_line += 1
            if not line:
                break
            else:
                if count_line >= 8:
                    fields = line.rstrip().split('\t')
                    distances.append(fields)
    colnames = []
    for i in distances[0]:
        colnames.append(i.replace(' ', ''))
    colnames.append('')
    colnames.append('id')
    df = pd.DataFrame(distances[1:len(distances)], columns=colnames)
    df = df.drop(labels='', axis=1)
    df[['id_code', 'number']] = df['id'].str.split(' ', expand=True)
    df = df.drop(labels='id', axis=1)
    for column in df:
        df[column] = df[column].str.replace(' ', '')
    return df


def distmatdf_to_csv(df):
    for c in range(0, len(df)):
        for i, r in df.iterrows():
            if df.iloc[i][c] == '':
                df.iloc[i][c] = df.iloc[c][i]
    return df


df_distmat = distmatdf_to_csv(distmat_to_df(distmat))

print(df_distmat)

df_distmat = df_distmat.drop(labels=['id_code', 'number'], axis=1)

with open(id_file, 'r') as infile:
    id_list = []
    while True:
        line = infile.readline().rstrip()
        if line != '':
            id_list.append(line)
        if not line:
            break

df_distmat.columns = id_list
df_distmat.to_csv(out_file)
