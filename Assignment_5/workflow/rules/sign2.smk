configfile: "config/config.yaml"
SAMPLES = config["samples"]

# rule all:
#     input:
#         s

rule bwa_map:
    input:
        config["datadir"] + "genome.fa",
        config["datadir"] + "samples/{sample}.fastq"
    output:
        config["resultsdir"] + "results/mapped_reads/{sample}.bam"
    threads:
        2
    benchmark:
        config["resultsdir"] + "benchmarks/bwa_map/{sample}.bwa.benchmark.txt"
    log:
        config["resultsdir"] + "logs/bwa_map/{sample}.bwa.log"
    message:
        "executing bwa mem on the following {input} to generate the following {output}"
    shell:
        "bwa mem {input} | samtools view -Sb - > {output}"

rule samtools_sort:
    input:
        config["resultsdir"] + "results/mapped_reads/{sample}.bam"
    output:
        config["resultsdir"] + "results/sorted_reads/{sample}.bam"
    benchmark:
        config["resultsdir"] + "benchmarks/sam_sort/{sample}.sam.sort.txt"
    log:
        config["resultsdir"] + "logs/sam_sort/{sample}.sort.log"
    message:
        "executing samtools sort on the following {input} to generate the following {output}"
    shell:
        "samtools sort -T sorted_reads/{wildcards.sample} "
        "-O bam {input} > {output}"

rule samtools_index:
    input:
        config["resultsdir"] + "results/sorted_reads/{sample}.bam"
    output:
        config["resultsdir"] + "results/sorted_reads/{sample}.bam.bai"
    benchmark:
        config["resultsdir"] + "benchmarks/sam_index/{sample}.sam.index.txt"
    log:
        config["resultsdir"] + "logs/sam_index/{sample}.index.log"
    message:
        "executing samtools index on the following {input} to generate the following {output}"
    shell:
        "samtools index {input}"

rule bcftools_call:
    input:
        fa=config["datadir"] + "genome.fa",
        bam=expand(config["resultsdir"] + "results/sorted_reads/{sample}.bam", sample=SAMPLES),
        bai=expand(config["resultsdir"] + "results/sorted_reads/{sample}.bam.bai", sample=SAMPLES)
    output:
        config["resultsdir"] + "results/calls/all.vcf"
    benchmark:
        config["resultsdir"] + "benchmarks/bcf_call/bcf.call.txt"
    log:
        config["resultsdir"] + "logs/bcf_call/bcf.call.log"
    message:
        "executing samtools mpileup and bfctools call on the following {input.fa} and {input.bam} to generate the following {output}"
    shell:
        "samtools mpileup -g -f {input.fa} {input.bam} | "
        "bcftools call -mv -O v - > {output}"

rule report:
    input:
        T1=config["resultsdir"] + "results/calls/all.vcf",
        T2=expand(config["resultsdir"] + "benchmarks/bwa_map/{sample}.bwa.benchmark.txt", sample=SAMPLES)

    output:
        html=config["resultsdir"] + "results/out.html"
    benchmark:
        config["resultsdir"] + "benchmarks/report/report.txt"
    log:
        config["resultsdir"] + "logs/report/report.log"
    message:
        "Creating report from {input} to generate the following {output} output won't have inbedded file due to errors"
    run:
        from snakemake.utils import report
        with open(input[0]) as f:
            n_calls = sum(1 for line in f if not line.startswith("#"))

        report("""
        An example workflow
        ===================================

        Reads were mapped to the Yeast reference genome
        and variants were called jointly with
        SAMtools/BCFtools.

        This resulted in {n_calls} variants (see Table T1_).
        Benchmark results for BWA can be found in the tables T2_
        """, output[0], metadata="Author: Mr Pipeline", T2=input.T2)
