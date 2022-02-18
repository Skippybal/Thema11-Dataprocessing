from snakemake.remote.HTTP import RemoteProvider as HTTPRemoteProvider

HTTP = HTTPRemoteProvider()

rule all:
    input:
        "results/http/test.txt"

rule get_data_bioinf:
    input:
        HTTP.remote("https://bioinf.nl/~fennaf/snakemake/test.txt")
    output:
        "results/http/test.txt"
    shell:
        "mv {input} {output}"
