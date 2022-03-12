configfile: "config/config.yaml"

# Doesn't need to be bellow rule all
include: "rules/bwa.smk"
include: "rules/samtools.smk"

rule all:
    input: config["resultsdir"] + 'results/out.vcf'
