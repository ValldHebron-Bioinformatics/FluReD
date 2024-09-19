![Static Badge](https://img.shields.io/badge/Version-Pre--Release-blue)    ![Static Badge](https://img.shields.io/badge/License-GPL_V3-green)

# Influenza reassortment detection program (FluReD)

This repository analyses influenza genomes for reassortment detection (currently available for influenza A and B), to understand one of the main causes of influenza evolution and spread.

Genotype is assigned independently for each segment through a method based on distances.

> [!IMPORTANT]
> Clade assignment is based on available sequences. For some clades, not all segments are available. For all segments of a reference strain, clade assigment is based on HA clade defined. 



## Available references

References datasets by season are available [here](references). A [guide](references/README.md) for own reference dataset creation is also provided.


## Installation

### Prerequisites

Ensure that the following programs/packages are installed on your system before running the pipeline:

- [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html) (developed with version 23.10.1)
- Python 3.x and the following modules:
    - pandas
    - sys
    - re
    - os
- [MAFFT](https://mafft.cbrc.jp/alignment/software/)
- [distmat](http://emboss.sourceforge.net/apps/cvs/emboss/apps/distmat.html)

### Installation Steps

1. Clone the repository:

    ```bash
    git clone https://github.com/ValldHebron-Bioinformatics/FluReD.git
    cd FluReD
    ```

2. Install **nextflow** (tool developed in version 23.10.1) Follow the [nextflow installation guide](https://www.nextflow.io/docs/latest/install.html)

3. Install the required Python packages. Can be installed with `pip install pandas sys re os`

4. Install **MAFFT** for sequence alignment. Follow the [MAFFT installation guide](https://mafft.cbrc.jp/alignment/software/).

5. Install **distmat** (for generating distance matrices). You can refer to the [distmat installation guide](http://emboss.sourceforge.net/apps/cvs/emboss/apps/distmat.html).

## Execution details

### Input

Parameters:
- `--fluType`: Type of influenza to be analysed. Available options are `[ A/H1 | A/H3 | B/Vic | B/Yam | Zoonotic ]`. If you want to analyse an influenza A dataset (taking into account both H1 and H3), you can define A/H1 or A/H3 as fluType parameter.
- `--outdir`: Output directory to store the results.
- `--fasta`: FASTA format file with the segments to be analysed. Currently, the tool is adapted for the GISAID format, which is necessary for its operation. The headers must have the format `>Isolation_name|Collection_date|Clade|Segment`. The options ‘Replace spaces with underscores in FASTA header’ and ‘Remove spaces before and after values in FASTA header’ must be selected.
- `--Npercent`: Threshold for sequence filtering based on the percentage Ns. Default is 0.05.
- `--chunk`: Chunk size for parallelisation. Default is 100.
- `--segments`: Segments for analysis. Default is ‘all’, but a single segment can be selected.

### Output

A folder named 'results' will be created in the directory defined by the user. Results will be stored in this folder in CSV format.

### Example:
```
nextflow run flured.nf --fluType A/H1 --outdir ./outputDir --fasta ./sequences.fasta --chunk 100 --references ./references/2023-2024/A-H1N1 --segments all
```
## Credits

If you use this tool in your research, please consider citing the repository.

## Get in touch

To report a bug, error, or feature request, please [open an issue](https://github.com/ValldHebron-Bioinformatics/FluReD/issues).

For questions, email us at alejandra.gonzalez@vallhebron.cat; we're happy to help!
