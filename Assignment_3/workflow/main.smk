'''
Main script to be executed.
Includes all necessary Snakefiles needed
to execute the workflow.
'''

configfile: "config/config.yaml"
include: "workflow/assignment2.smk"
include: "workflow/ncbi_improved.smk"
include: "workflow/ncbi.smk"
include: "workflow/vremote.smk"
include: "workflow/remote.smk"


rule all:
    input:
        ""
