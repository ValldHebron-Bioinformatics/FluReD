#!/usr/bin/env nextflow
    
nextflow.enable.dsl = 2

/**
STEP 0. 
    
Filter sequences and divide in chunks.
By default, 5% of Ns are allowed and chunks of 100 are generated.
*/

process NPERCENT {
    publishDir "$params.outdir/results", pattern: '*_filt_Ns.txt', mode: 'copy'

    input:
    path fastainFile

    output:
    path '*_output1.fasta'
    path '*_filt_Ns.txt'

    script:
    """
    python3 $projectDir/bin/NpercentageFilter.py -in $fastainFile -out ${fastainFile.baseName}_output1.fasta -filt ${fastainFile.baseName}_filt_Ns.txt -percentage $params.Npercent
    """
    
}


process DEGBASES {
    publishDir "$params.outdir/results", pattern: '*_filt_degenerate-bases.txt', mode: 'copy'

    input:
    path fastainFile
    path filtFile

    output:
    path '*_output.fasta'
    path '*_filt_degenerate-bases.txt'

    script:
    """
    python3 $projectDir/bin/DbasesFilter.py -in $fastainFile -out ${fastainFile.baseName}_output.fasta -filt ${fastainFile.baseName}_filt_degenerate-bases.txt
    """
    
}


process SPLITSEGMENTS {
    
    input:
    path fastaFiltered
    path filtFile
    val x

    output:
    path '*_output.fasta'

    script:
    """
    python3 $projectDir/bin/splitSegments.py -in $fastaFiltered -segments $x
    """
 
}


process SPLITCHUNKS {

    input:
    val y 
    path chunkfilein

    output:
    path '*_chunk_*'

    script:
    """
    awk 'BEGIN {n_seq=0;} /^>/ {if(n_seq%$y==0){file=sprintf("${chunkfilein.baseName}_chunk_%d.fasta",n_seq);} print >> file; n_seq++; next;} { print >> file; }' < $chunkfilein
    """

}


//
