#!/usr/bin/env python3
import sys
import re
import os

for i in range(len(sys.argv)):
    if sys.argv[i] == "-in":
        file1 = sys.argv[i+1]
    elif sys.argv[i] == "-segments":
        segment = sys.argv[i+1]

if segment == "all":
    segment = ["HA", "MP", "NA", "NP", "NS", "PA", "PB1", "PB2"]
else:
    segment = [segment]

for s in segment:
    file2 = s+"_"+os.path.basename(file1)
    with open(file2, 'w') as outfile:
        with open(file1, 'r') as infile:
            while True:
                line = infile.readline()
                if not line:
                    break
                else:
                    if line.startswith(">"):
                        value = 0
                        if re.search(s, line.split("|")[-2]):
                            value = 1
                            outfile.write(line)
                        else:
                            continue
                    else:
                        if value == 1:
                            outfile.write(line)
                        else:
                            continue
        outfile.write('\n')

outfile.close()
infile.close()
