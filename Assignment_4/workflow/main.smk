configfile: "config/config.yaml"

rule all:
    input: config["resultsdir"] + 'result/heatmap.jpg'

include: "rules/heatmap.smk"
