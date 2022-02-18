from snakemake.remote.NCBI import RemoteProvider as NCBIRemoteProvider
NCBI = NCBIRemoteProvider(email="k.a.notebomer@st.hanze.nl") # email required by NCBI to prevent abuse

rule all:
    input:
        "results/ncbi_improved/sequence.fasta"

rule download_and_count:
    input:
        NCBI.remote("KY785484.1.fasta", db="nuccore")
    output:
        "results/ncbi_improved/sequence.fasta"
    run:
        shell("mv {input} {output}")
