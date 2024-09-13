#!/usr/bin/env nextflow
    

nextflow.enable.dsl = 2


/**
STEP 1. 
    
Merge the chunks with the references and align.
*/

process ALIGNREFS { 

    input:
    path chunksFiles

    output:
    path '*_refs.fasta'
    path '*_refs_mafft.fasta'
    
    script:
    """
    #!/bin/bash
    s=\$(echo ${chunksFiles} | cut -d'_' -f1)
    refFile=\$(ls $projectDir/${params.references} | grep "\$s")
    cat $projectDir/${params.references}/"\$refFile" ${chunksFiles} > ${chunksFiles.baseName}_refs.fasta
    mafft ${chunksFiles.baseName}_refs.fasta > ${chunksFiles.baseName}_refs_mafft.fasta
    """
    
}


process DISTMAT { 

    input:
    path mergedFiles
    path alignFiles

    output:
    path '*.distmat'
    path '*_ids.txt'
    
    script:
    """
    cat $alignFiles | grep ">" | cut -d'>' -f2 | cut -d'|' -f1 > ${alignFiles.baseName}_ids.txt
    distmat -sequence $alignFiles -nucmethod 0 -outfile ${alignFiles.baseName}.distmat
    """
}


process DISTMAT2CSV { 

    input:
    path distmatFiles
    path idsFiles

    output:
    path '*_matrix.csv'
    
    script:
    """
    python3 $projectDir/bin/distmat2csv.py -distmat ${distmatFiles} -out ${distmatFiles.baseName}_matrix.csv -ids ${idsFiles}
    """
}

    

process REASSORTMENTDETECTOR { 

    input:
    path distmatCSV

    output:
    path '*_genotype.csv'
    
    script:
    """
    refIds=\$(ls $projectDir/${params.references} | grep "_references.csv")
    python3 $projectDir/bin/distmatAnalyser.py -distmat ${distmatCSV} -refsIds $projectDir/${params.references}/"\$refIds"
    """
}

process MERGEOUTPUT { 
    publishDir "$params.outdir/results", pattern: '*_genotypes.csv', mode: 'copy'

    input:
    path segmentGenotype

    output:
    file 'reassortment_genotypes.csv'
    
    script:
    """
    echo "segment,ids,genotype" > reassortment_genotypes.csv
    for file in $segmentGenotype; do
        tail -n +2 \$file>> reassortment_genotypes.csv
    done
    """
}
