process FILTER_VARIANTS {
    tag "$meta.id"
    container 'broadinstitute/gatk:4.5.0.0'
    publishDir "${params.outdir}/variants", mode: 'copy'

    input:
    tuple val(meta), path(vcf), path(tbi)
    path fasta
    path fai
    path dict

    output:
    tuple val(meta), path("${meta.id}.filtered.vcf.gz"), path("${meta.id}.filtered.vcf.gz.tbi"), emit: vcf

    script:
    """
    gatk VariantFiltration \\
        -R $fasta \\
        -V $vcf \\
        --filter-expression "QD < 2.0" --filter-name "QD2" \\
        --filter-expression "FS > 60.0" --filter-name "FS60" \\
        --filter-expression "MQ < 40.0" --filter-name "MQ40" \\
        --filter-expression "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \\
        --filter-expression "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \\
        --filter-expression "SOR > 3.0" --filter-name "SOR3" \\
        -O ${meta.id}.filtered.vcf.gz
    """
}
