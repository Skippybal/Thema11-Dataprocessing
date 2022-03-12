rule sam_view:
    input:
        aln = config["resultsdir"] + "results/alligned/out.sam",
    output:
        config["resultsdir"] + 'results/temp/out.bam'
    shell:
        "samtools view -S -b {input.aln} > {output}"

rule sam_sort:
    input:
        aln_bam = config["resultsdir"] + "results/temp/out.bam",
    output:
        config["resultsdir"] + 'results/sorted/out.sorted.bam'
    shell:
        "samtools sort {input.aln_bam} > {output}"

rule picard_dedup:
    input:
        sorted = config["resultsdir"] + "results/sorted/out.sorted.bam",
        picard = config["picard"]
    output:
        out_file = config["resultsdir"] + 'results/filtered/out.dedup.bam',
        matrics = config["resultsdir"] + 'results/matrics/out.matrics'
    shell:
        "java -jar {input.picard} MarkDuplicates \
        MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 METRICS_FILE={output.matrics} \
        REMOVE_DUPLICATES=true ASSUME_SORTED=true VALIDATION_STRINGENCY=LENIENT \
        INPUT={input.sorted} OUTPUT={output.out_file}"

rule sam_index:
    input:
        dedup = config["resultsdir"] + "results/filtered/out.dedup.bam",
    output:
        touch(config["resultsdir"] + 'results/sam_index.done')
    shell:
        "samtools index {input.dedup}"

rule sam_pileup:
    input:
        check = config["resultsdir"] + 'results/sam_index.done',
        ref = config["datadir"] + "reference.fa",
        dedup = config["resultsdir"] + "results/filtered/out.dedup.bam",
    output:
        config["resultsdir"] + 'results/out.vcf'
    shell:
        "samtools mpileup -uf {input.ref} {input.dedup} |"
        " bcftools view -> {output}"
