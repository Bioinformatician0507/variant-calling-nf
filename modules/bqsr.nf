process BASE_RECALIBRATOR {
    tag "$meta.id"
    container 'broadinstitute/gatk:4.5.0.0'
    publishDir "${params.outdir}/bqsr", mode: 'copy'

    input:
    tuple val(meta), path(bam), path(bai)
    path fasta
    path fai
    path dict
    path known_sites
    path known_sites_tbi

    output:
    tuple val(meta), path("${meta.id}.recal.table"), emit: table

    script:
    """
    gatk BaseRecalibrator \\
        -I $bam \\
        -R $fasta \\
        --known-sites $known_sites \\
        -O ${meta.id}.recal.table
    """
}

process APPLY_BQSR {
    tag "$meta.id"
    container 'broadinstitute/gatk:4.5.0.0'
    publishDir "${params.outdir}/bqsr", mode: 'copy'

    input:
    tuple val(meta), path(bam), path(bai), path(recal_table)
    path fasta
    path fai
    path dict

    output:
    tuple val(meta), path("${meta.id}.recal.bam"), path("${meta.id}.recal.bai"), emit: bam

    script:
    """
    gatk ApplyBQSR \\
        -I $bam \\
        -R $fasta \\
        --bqsr-recal-file $recal_table \\
        -O ${meta.id}.recal.bam
    """
}
