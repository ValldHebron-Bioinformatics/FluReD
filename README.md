![Static Badge](https://img.shields.io/badge/Version-Pre--Release-blue)    ![Static Badge](https://img.shields.io/badge/License-GPL_V3-green)

# Influenza reassortment detection program (FluReD)

This repository analyzes influenza genomes for reassortment detection (currently available for influenza A and B), to understand one of the main causes of influenza evolution and spread.

Genotype is assigned independently for each segment through a method based on distances.

> [!IMPORTANT]
> Genotype assignment is based on available sequences. For some genotypes, not all segments are available.



## Available references

References datasets for season 2023-2024 are available [here](folder)

## Requirements

For correct execution, the following programs/packages need to be installed:
- Nextflow (developed in version 23.10.1). [Installation guide](https://www.nextflow.io/docs/latest/install.html)
- Python modules **pandas**, **sys**, **re**, **os**. Can be installed with `pip install pandas sys re os` 
- mafft. [Installation guide](https://mafft.cbrc.jp/alignment/software/source.html)
- distmat [Installation guide](http://emboss.open-bio.org/html/adm/index.html)

## Execution

```
nextflow run flured.nf --fluType A/H1 --outdir ./test-genotyping2 --fasta ./h1n1_sequences.fasta --chunk 100 --references ./references/2023-2024/A-H1N1 --segments all
```





## Get in touch

To report a bug, error, or feature request, please [open an issue](https://github.com/alejandra-gonzalezsanchez/fluredep/issues).

For questions, email us at alejandra.gonzalez@vallhebron.cat; we're happy to help!

## References
