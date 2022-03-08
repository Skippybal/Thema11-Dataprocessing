input <- "data/gene_ex.csv"
d <- as.matrix(read.csv(input, header=FALSE, sep=",")[-1,-1])
rownames(d) <- read.csv(input, header=FALSE, sep=",")[-1,1]
colnames(d) <- read.csv(input, header=FALSE, sep=",")[1,-1]
jpeg("results/heatmap.jpg")
heatmap(d)
dev.off()