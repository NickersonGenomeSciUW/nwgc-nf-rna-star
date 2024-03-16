process DEEPTOOLS_BAM_COVERAGE {

    label "DEEPTOOLS_BAM_COVERAGE${params.sampleId}_${params.userId}"

    publishDir "${params.bigWigDirectory}", mode:  'link', pattern: "*.bw"

    input:
        tuple val(chromosome), val(strand)
        bam
        bai

    output:
        path "versions.yaml", emit: versions

    script:

        """
        bamCoverage \
            --bam $bam \
            --region $chromosome \
            --filterRNAstrand $strand \
            --effectiveGenomeSize 2913022398 \
            --binSize 1 \
            --outFileFormat bigwig \
            --normalizeUsing RPGC \
            --numberOfProcessors 1 \
            --outFileName ${params.sampleDirectory}.$chromosome.$strand.bw

        cat <<-END_VERSIONS > versions.yaml
        '${task.process}':
            bamCoverage: \$(bamCoverage --version | awk '{print \$2}')
            python: \$(python --version | awk '{print \$2}')
        END_VERSIONS

        """

}