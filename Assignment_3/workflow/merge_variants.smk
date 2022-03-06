from snakemake.remote.HTTP import RemoteProvider as HTTPRemoteProvider

HTTP = HTTPRemoteProvider()

SAMPLES = [x for x in 'ABDEFGHIJ']

import os

file_path = os.getcwd()

configfile: f"config/config.yaml"
#SAMPLES: config['samples']
#URL: config["url"]

# rule all:
#     input:
#         "results/calls/merged_results.bam"
       #expand("results/data/{sample}.bam", sample=SAMPLES)

# rule download:
#     output:
#        "results/data/{sample}.bam"
#     shell:
#         "wget {url}{wildcards.sample}.bam"

rule download:
    input:
        HTTP.remote(config["url"] + "{sample}.bam")
    output:
        temp("results/data/{sample}.bam")
    shell:
        "mv {input} {output}"

rule merge_variants:
    input:
         bam=expand("results/data/{sample}.bam", sample=SAMPLES)
    output:
        "results/calls/merged_results.bam"
    message: "Executing samtools merge with {threads} threads on the following files {input}."
    shell:
        "samtools merge {output} {input.bam} "
