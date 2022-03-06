#workdir: "/home/skippybal/PycharmProjects/Thema11-Dataprocessing/Assignment_2/data/"

# Setting workdir is not the besst solution here seeing as we are
# only interested in the place where we get our data from
# If we were to set the working wirectory to the data directory
# the program would also write output to that data file
# That isn't the best solution
# Or we need to give an absolute path to output, but this is better

from os.path import join
DATA_DIR = "/home/skippybal/PycharmProjects/Thema11-Dataprocessing/Assignment_2/data/"

SAMPLES_DIR = 'samples/'
SAMPLES = ["A", "B", "C"]

# rule all:
#     input:
#         "results/assignment2/out.html"

rule bwa_map:
    input:
        genome = join(DATA_DIR, "genome.fa"),
        fastq = join(DATA_DIR, SAMPLES_DIR, "{sample}.fastq")
    output:
        "results/assignment2/mapped_reads/{sample}.bam"
    message:
        "executing bwa mem on the following {input} to generate the following {output}"
    shell:
        "bwa mem {input} | samtools view -Sb - > {output}"

rule samtools_sort:
    input:
        "results/assignment2/mapped_reads/{sample}.bam"
    output:
        "results/assignment2/sorted_reads/{sample}.bam"
    message:
        "executing samtools sort on the following {input} to generate the following {output}"
    shell:
        "samtools sort -T sorted_reads/{wildcards.sample} "
        "-O bam {input} > {output}"

rule samtools_index:
    input:
        "results/assignment2/sorted_reads/{sample}.bam"
    output:
        "results/assignment2/sorted_reads/{sample}.bam.bai"
    message:
        "executing samtools index on the following {input} to generate the following {output}"
    shell:
        "samtools index {input}"

rule bcftools_call:
    input:
        fa=join(DATA_DIR, "genome.fa"),
        bam=expand("results/assignment2/sorted_reads/{sample}.bam", sample=SAMPLES),
        bai=expand("results/assignment2/sorted_reads/{sample}.bam.bai", sample=SAMPLES)
    output:
        "results/assignment2/calls/all.vcf"
    message:
        "executing samtools mpileup and bfctools call on the following {input.fa} and {input.bam} to generate the following {output}"
    shell:
        "samtools mpileup -g -f {input.fa} {input.bam} | "
        "bcftools call -mv -O v - > {output}"

rule report:
    input:
        "results/assignment2/calls/all.vcf"
    output:
        html="results/assignment2/out.html"
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
        """, output[0], metadata="Author: Mr Pipeline")
