process MARK_DUPLICATES {
    tag "$meta.id"
    container 'broadinstitute/gatk:4.5.0.0'
    publishDir "${params.outdir}/markdup", mode: 'copy'

    input:
    tuple val(meta), path(bam), path(bai)

    output:
    tuple val(meta), path("${meta.id}.markdup.bam"), path("${meta.id}.markdup.bai"), emit: bam
    path "${meta.id}.markdup.metrics.txt", emit: metrics

    script:
    """
    gatk MarkDuplicates \\
        -I $bam \\
        -O ${meta.id}.markdup.bam \\
        -M ${meta.id}.markdup.metrics.txt \\
        --CREATE_INDEX true
    """
}
