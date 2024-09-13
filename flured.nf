#!/usr/bin/env nextflow
    
nextflow.enable.dsl = 2

include { NPERCENT; DEGBASES; SPLITSEGMENTS; SPLITCHUNKS } from './modules/sequences_pre-analysis'
include { ALIGNREFS; DISTMAT; DISTMAT2CSV; REASSORTMENTDETECTOR; MERGEOUTPUT } from './modules/reassortment_detection'

def versionMessage() 
{
    log.info"""
     
    INFLUENZA REASSORTMENT DETECTION PROGRAM (FluReD) - Version: ${workflow.manifest.version} 
    """.stripIndent()
}

def helpMessage() 
{
    log.info"""

INFLUENZA REASSORTMENT DETECTION PROGRAM (FluReD) - Version: ${workflow.manifest.version} 

Usage: nextflow run flured.nf PARAMETERS [args] OPTIONS [args]

Parameters:
   --fluType
       Define influenza type. Available options: [ A/H1 | A/H3 | B/Vic | B/Yam | Zoonotic ]
   --outdir
       Define output directory. Inside it, a results folder will be created containing output files.
   --fasta
       Path to fasta file containing the segments sequences. 

Options:
   --help
       Prints help message.
   --version
       Prints version.
   --segments
       Segments to genotype. By default, all segments will be genotyped. Alternatively, one segment can be defined to genotype.
   --Npercent
       Frequency of Ns allowed for the analysis. By default = 0.05
       Sequences with a higher percentage of Ns will be filtered out and listed in outdir/results/[NAME OF FASTA]_filt.txt
   --chunk
       Numer of sequences by chunk. By default = 100

"""
}

/**
Prints version when asked for
*/
if (params.version) {
    versionMessage()
    exit 0
}

/**
Prints help when asked for
*/

if (params.help) {
    helpMessage()
    exit 0
}

/**
STEP 0. 
    
Checks input parameters and (if it does not exists) creates the directory 
where the results will be stored (aka working directory). 
*/


//Checking user-defined parameters  
if (!params.fluType) {
    exit 1, "Please, define influenza type for segments genotyping. Choose any of [ A/H1 | A/H3 | B/Vic | B/Yam | Zoonotic ]"
}   

if (params.fluType != "A/H1" && params.fluType != "A/H3" && params.fluType != "B/Vic" && params.fluType != "B/Yam" && params.fluType != "Zoonotic") {
    exit 1, "Influenza type not available. Choose any of [ A/H1 | A/H3 | B/Vic | B/Yam | Zoonotic ]"
}   

if (!params.outdir) {
    exit 1, "Please, define output directory"
}   

if (!params.fasta) {
    exit 1, "Please, define input fasta"
}   


//Creates working dir
workingpath = params.outdir
workingdir = file(workingpath)
if( !workingdir.exists() ) {
    if( !workingdir.mkdirs() )  {
        exit 1, "Cannot create output directory: $workingpath"
    } 
}   

// Header log info
log.info """


INFLUENZA REASSORTMENT DETECTION PROGRAM (FluReD)
___________________________________________________

"""

def summary = [:]

summary['Starting time'] = new java.util.Date() 
//Environment
summary['Pipeline name'] = workflow.manifest.name
summary['Pipeline version'] = workflow.manifest.version

summary['Nextflow version'] = nextflow.version.toString() + " build " + nextflow.build.toString() + " (" + nextflow.timestamp + ")"

summary['Java version'] = System.getProperty("java.version")

summary['Operating system'] = System.getProperty("os.name") + " " + System.getProperty("os.arch") + " v" +  System.getProperty("os.version")
summary['User name'] = System.getProperty("user.name") //User's account name

//General
summary['Influenza type'] = params.fluType 

//Folders
summary['Output directory'] = workingpath

log.info summary.collect { k,v -> "${k.padRight(27)}: $v" }.join("\n")
log.info ""





// Workflow

workflow {

    segmentTask = Channel.of(params.segments).first()
    chunknum = Channel.of(params.chunk).first()
    fastain = Channel.fromPath(params.fasta) 

    // Filter fasta by N percentage
    npercent_ch = NPERCENT(fastain)
    // Filter fasta by degenerate bases
    degbases_ch = DEGBASES(npercent_ch)
    // Separate by segment
    segments_ch = SPLITSEGMENTS(degbases_ch, segmentTask)
    // Divide in chunks
    split_ch = SPLITCHUNKS(chunknum, segments_ch.flatten())
    // Align chunks to references
    align_ch = ALIGNREFS(split_ch.flatten())
    // Generate distmat
    distmat_ch = DISTMAT(align_ch)
    // Get genotype by segment
    distmatcsv_ch = DISTMAT2CSV(distmat_ch)
    reassort_ch = REASSORTMENTDETECTOR(distmatcsv_ch)
    outfile_ch = MERGEOUTPUT(reassort_ch.collect())
}
