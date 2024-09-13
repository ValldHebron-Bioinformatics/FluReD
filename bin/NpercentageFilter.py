#!/usr/bin/env python3
import sys

for i in range(len(sys.argv)):
    if sys.argv[i] == "-in":
        filein = sys.argv[i+1]
    elif sys.argv[i] == "-out":
        fileout = sys.argv[i+1]
    elif sys.argv[i] == "-filt":
        filefilt = sys.argv[i+1]
    elif sys.argv[i] == "-percentage":
        p = sys.argv[i+1]


def N_percentage(sequence):
    nt_N = 0
    for nt in (sequence.upper().rstrip()):
        if (nt == "N"):
            nt_N += 1
    return round(nt_N / len(sequence), 2)


# Create dictionary of sequences
sequences = {}
sequence_array = []
header = ""
with open(filein, 'r') as infile:
    while True:
        line = infile.readline()
        if not line:
            sequence = "".join(sequence_array)
            sequences[header] = sequence
            break
        else:
            if line.startswith(">"):
                if sequence_array == []:
                    header = line[1:].rstrip()
                else:
                    sequence = "".join(sequence_array)
                    sequences[header] = sequence
                    sequence_array = []
                    header = line[1:].rstrip()
            else:
                sequence_array.append(line.rstrip())
infile.close()


with open(fileout, 'w') as outfile:
    with open(filefilt, 'w') as filtfile:
        for s in sequences:
            if (N_percentage(sequences[s]) < float(p)):
                outfile.write(">")
                outfile.write(s)
                outfile.write('\n')
                outfile.write(sequences[s])
                outfile.write('\n')
            else:
                filtfile.write(s)
                filtfile.write('\n')
