include { MARK_DUPLICATES                    } from './modules/mark_duplicates'
include { BASE_RECALIBRATOR; APPLY_BQSR      } from './modules/bqsr'
include { HAPLOTYPE_CALLER                   } from './modules/haplotype_caller'

workflow {
    if (!params.input) {
        error "Please provide a samplesheet with --input"
    }

    ch_reads = channel
        .fromPath(params.input, checkIfExists: true)
        .splitCsv(header: true)
        .map { row ->
            def meta = [id: row.sample]
            [meta, file(row.bam), file(row.bai)]
        }

    MARK_DUPLICATES(ch_reads)

    BASE_RECALIBRATOR(
        MARK_DUPLICATES.out.bam,
        file(params.fasta),
        file(params.fai),
        file(params.dict),
        file(params.known_sites),
        file(params.known_sites_tbi)
    )

    ch_bam_and_table = MARK_DUPLICATES.out.bam
        .join(BASE_RECALIBRATOR.out.table)

    APPLY_BQSR(
        ch_bam_and_table,
        file(params.fasta),
        file(params.fai),
        file(params.dict)
    )

    HAPLOTYPE_CALLER(
        APPLY_BQSR.out.bam,
        file(params.fasta),
        file(params.fai),
        file(params.dict)
    )
}
