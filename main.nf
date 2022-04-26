#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { fastp } from './modules/mykrobe.nf'
include { mykrobe_predict } from './modules/mykrobe.nf'

workflow {
  ch_fastq = Channel.fromFilePairs( params.fastq_search_path, flat: true ).filter{ !( it[0] =~ /Undetermined/ ) }.map{ it -> [it[0].split('_')[0], it[1], it[2]] }
  fastp(ch_fastq)
  mykrobe_predict(fastp.out.reads)
}
