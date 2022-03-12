rule bwa_index:
    input:
        ref = config["datadir"] + "reference.fa"
    output:
        touch(config["resultsdir"] + 'results/bwa_index.done')
    shell:
        "bwa index {input.ref}"

rule bwa_aln:
    input:
        check = config["resultsdir"] + "results/bwa_index.done",
        ref = config["datadir"] + "reference.fa",
        # This needs to become expand with the config file
        reads = expand(config["datadir"] + "{sample}", sample=config["samples"])
        #reads = config["datadir"] + "A.txt"
    output:
        config["resultsdir"] + "results/temp/out.sai"
    shell:
        "bwa aln -I -t 8 {input.ref} {input.reads} > {output}"

rule bwa_samse:
    input:
        ref = config["datadir"] + "reference.fa",
        aln = config["resultsdir"] + "results/temp/out.sai",
        reads = expand(config["datadir"] + "{sample}", sample=config["samples"])
    output:
        config["resultsdir"] + 'results/alligned/out.sam'
    shell:
        "bwa samse {input.ref} {input.aln} {input.reads} > {output}"
