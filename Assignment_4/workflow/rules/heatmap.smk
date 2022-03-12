rule make_heatmap:
    """ rule that creates histogram from gene expression counts"""
    input:
        config["datadir"] + 'gene_ex.csv'
    output:
         config["resultsdir"] + 'result/heatmap.jpg'
    shell:
        "Rscript workflow/scripts/script.R {input} {output}"
