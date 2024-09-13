![Static Badge](https://img.shields.io/badge/Version-Pre--Release-blue)    ![Static Badge](https://img.shields.io/badge/License-GPL_V3-green)

# Influenza reassortment detection program (FluReD)

This repository analyses influenza genomes for reassortment detection (currently available for influenza A and B), to understand one of the main causes of influenza evolution and spread.

Genotype is assigned independently for each segment through a method based on distances.

> [!IMPORTANT]
> Genotype assignment is based on available sequences. For some genotypes, not all segments are available.



## Available references

References datasets by season are available [here](references). A [guide](references/README.md) for own reference dataset creation is also provided.

## Requirements

For correct execution, the following programs/packages need to be installed:
- Nextflow (developed in version 23.10.1). [Installation guide](https://www.nextflow.io/docs/latest/install.html)
- Python modules **pandas**, **sys**, **re**, **os**. Can be installed with `pip install pandas sys re os` 
- mafft. [Installation guide](https://mafft.cbrc.jp/alignment/software/source.html)
- distmat [Installation guide](http://emboss.open-bio.org/html/adm/index.html)

## Execution details

### Input

Parameters:
- fluType = Type of influenza to analyse. The available options are [ A/H1 | A/H3 | B/Vic | B/Yam | Zoonotic ]. If you want to analyse a dataset of inluenza A (taking into account both H1 and H3), you can define either A/H1 or A/H3 as fluType parameter.
- outdir = Output directory to store the results.
- fasta =  File in FASTA format with the segments to analyse. Currently, the tool is adapted for GISAID format, and is requiered for its functioning. Headers should be in the format: >Isolate_name|Collection_date|Clade|Segment. Options 'Replace spaces with underscores in FASTA header' and 'Remove spaces before and after values in FASTA header' should be selected.
- Npercent = 0.05
- chunk = 100
- segments = 'all'

### Output


Example:
```
nextflow run flured.nf --fluType A/H1 --outdir ./test-genotyping2 --fasta ./h1n1_sequences.fasta --chunk 100 --references ./references/2023-2024/A-H1N1 --segments all
```





## Get in touch

To report a bug, error, or feature request, please [open an issue]([issues](https://github.com/ValldHebron-Bioinformatics/FluReD/issues)).

For questions, email us at alejandra.gonzalez@vallhebron.cat; we're happy to help!

## References
