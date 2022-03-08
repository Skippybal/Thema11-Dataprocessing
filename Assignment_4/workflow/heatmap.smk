from snakemake.utils import R
datadir= 'data/'

rule all:
    """ final rule """
    input: 'result/heatmap.jpg'


rule make_heatmap:
    """ rule that creates histogram from gene expression counts"""
    input:
        datadir + 'gene_ex.csv'
    output:
         'result/heatmap.jpg'
    run:
        R("""
        input <- {input}
        d <- as.matrix(read.csv(input, header=FALSE, sep=",")[-1,-1])
        rownames(d) <- read.csv('input, header=FALSE, sep=",")[-1,1]
        colnames(d) <- read.csv(input, header=FALSE, sep=",")[1,-1]
        jpeg("{output}")
        heatmap(d)
        dev.off()
        """)