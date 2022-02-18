import os
from snakemake.remote.NCBI import RemoteProvider as NCBIRemoteProvider
NCBI = NCBIRemoteProvider(email="k.a.notebomer@st.hanze.nl")

rule all:
    input:
        NCBI.remote("KY785484.1.fasta", db="nuccore")
    run:
        base = os.path.basename(input[0])
        outpath = "results/ncbi/"
        outputName = f"{outpath}{base}"
        shell("mkdir -p {outpath} && touch {outputName} &&"
              "mv {input} {outputName}")
