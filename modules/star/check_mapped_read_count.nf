process CHECK_MAPPED_READ_COUNT {

    label "CHECK_MAPPED_READ_COUNT_${params.sampleId}_${params.userId}"

    input:
        path bam
        path bai

    output:
        env MAPPED_READS_FROM_SAMTOOLS, emit: readCount

    script:
        """
        MAPPED_READS_FROM_SAMTOOLS=0
        
        ## Use samtools to find mapped reads (first try idxstats as it is faster)
        MAPPED_READS_FROM_SAMTOOLS=`samtools idxstats $bam | awk '{sum+=\$3} {print sum}' | tail -n 1`
        if [ \$MAPPED_READS_FROM_SAMTOOLS == 0 ] ; then
            MAPPED_READS_FROM_SAMTOOLS=`samtools flagstat $bam | head -n 5 |tail -n 1  | awk '{print \$1'}`
        fi
        """
}
