process mykrobe_predict {

  tag { sample_id }

  publishDir "${params.outdir}/${sample_id}", mode: 'copy', pattern: "${sample_id}_mykrobe.{csv,json}"

  input:
    tuple val(sample_id), path(reads_1), path(reads_2)

  output:
    tuple val(sample_id), path("${sample_id}_mykrobe.csv"), emit: csv
    tuple val(sample_id), path("${sample_id}_mykrobe.json"), emit: json

  script:
    """
    mykrobe predict --threads ${task.cpus} --sample ${sample_id} --species ${params.species} -i ${reads_1} ${reads_2} --format json_and_csv --output ${sample_id}_mykrobe
    """
}
