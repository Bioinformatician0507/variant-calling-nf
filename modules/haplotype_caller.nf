process HAPLOTYPE_CALLER {
    tag "$meta.id"
    container 'broadinstitute/gatk:4.5.0.0'
    publishDir "${params.outdir}/variants", mode: 'copy'

    input:
    tuple val(meta), path(bam), path(bai)
    path fasta
    path fai
    path dict

    output:
    tuple val(meta), path("${meta.id}.vcf.gz"), path("${meta.id}.vcf.gz.tbi"), emit: vcf

    script:
    """
    gatk HaplotypeCaller \\
        -I $bam \\
        -R $fasta \\
        -O ${meta.id}.vcf.gz
    """
}
