from snakemake.remote.NCBI import RemoteProvider as NCBIRemoteProvider
NCBI = NCBIRemoteProvider(email="k.a.notebomer@st.hanze.nl")

#import os

#file_path = os.getcwd()

#configfile: f"{file_path}/../config/config.yaml"
configfile: f"config/config.yaml"
workdir: config["workdir"]

query = '"Zika virus"[Organism] AND (("9000"[SLEN] : "20000"[SLEN]) AND ("2017/03/20"[PDAT] : "2017/03/24"[PDAT])) '
accessions = NCBI.search(query, retmax=3)

input_files = expand("{acc}.fasta", acc=accessions)

# rule all:
#     input:
#         "results/ncbi_improved_improved/mf.txt"

rule download_and_count:
    input:
        NCBI.remote(input_files, db="nuccore", seq_start=5000)

    output:
        "results/ncbi_improved_improved/mf.txt"
    run:
        shell("cat {input} >> {output}")
