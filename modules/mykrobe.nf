process fastp {

  tag { sample_id }

  publishDir params.versioned_outdir ? "${params.outdir}/${sample_id}/${params.pipeline_short_name}-v${params.pipeline_minor_version}-output" : "${params.outdir}/${sample_id}", pattern: "${sample_id}_fastp.{json,csv}", mode: 'copy'

  input:
  tuple val(sample_id), path(reads_1), path(reads_2)

  output:
  tuple val(sample_id), path("${sample_id}_fastp.json"), emit: fastp_json
  tuple val(sample_id), path("${sample_id}_fastp.csv"), emit: fastp_csv
  tuple val(sample_id), path("${sample_id}_trimmed_R1.fastq.gz"), path("${sample_id}_trimmed_R2.fastq.gz"), emit: reads

  script:
  """
  fastp -i ${reads_1} -I ${reads_2} -o ${sample_id}_trimmed_R1.fastq.gz -O ${sample_id}_trimmed_R2.fastq.gz
  mv fastp.json ${sample_id}_fastp.json
  fastp_json_to_csv.py -s ${sample_id} ${sample_id}_fastp.json > ${sample_id}_fastp.csv
  """
}


process mykrobe_predict {

  tag { sample_id }

  publishDir params.versioned_outdir ? "${params.outdir}/${sample_id}/${params.pipeline_short_name}-v${params.pipeline_minor_version}-output" : "${params.outdir}/${sample_id}", mode: 'copy', pattern: "${sample_id}_mykrobe.{csv,json}"

  input:
    tuple val(sample_id), path(reads_1), path(reads_2)

  output:
    tuple val(sample_id), path("${sample_id}_mykrobe.csv"), emit: csv
    tuple val(sample_id), path("${sample_id}_mykrobe.json"), emit: json

  script:
    """
    mykrobe predict --threads ${task.cpus} --sample ${sample_id} --species ${params.species} -i ${reads_1} ${reads_2} --format json_and_csv --output ${sample_id}_mykrobe
    mv ${sample_id}_mykrobe.csv ${sample_id}_mykrobe_unformatted.csv
    format_mykrobe_csv.py ${sample_id}_mykrobe_unformatted.csv > ${sample_id}_mykrobe.csv
    """
}
