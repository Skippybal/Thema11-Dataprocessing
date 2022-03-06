'''
Main script to be executed.
Includes all necessary Snakefiles needed
to execute the workflow.
'''

configfile: "config/config.yaml"
include: "../workflow/assignment2_rewrite.smk"
include: "../workflow/ncbi_iproved_improved.smk"
include: "../workflow/remote.smk"
include: "../workflow/merge_variants.smk"


rule all:
    input:
        "results/calls/merged_results.bam",
        "results/http/test.txt",
        "results/assignment2/out.html",
        "results/ncbi_improved_improved/mf.txt"
