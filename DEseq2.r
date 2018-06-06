# Use "merge2_htseq_tab.txt" as DEseq2 input file.

source("https://bioconductor.org/biocLite.R")
biocLite("DESeq2")

library(DESeq2)
library("gplots")
library("RColorBrewer")
library(pheatmap)

#Set working directory 
setwd("~/merge2_htseq_tab.txt")
directory <- "~/merge2_htseq_tab.txt/"

#Open tab file with htseq output
file<-paste(directory, "merge2_htseq_tab.txt", sep="") 

#Define conditions for each sample

> cond<-c("s20170005", "s20170011","s20170012", "s20170020", "s20170021" ,"s20170022", "s20170027", "s20170030", "s20170034", "s20170038", "s20170039", "s20170042", "s20170054", "s20170055", "s20170056", "s20170058", "s20170059", "s20170060", "s20170065", "s20170067", "s20170096", "s20170098", "s20170103", "s20170104", "s20170108", "s20170110", "s20170113", "s20170117", "s20170119", "s20170120", "s20170133", "s20170134", "s20170135", "W10" ,"W11" ,"W5", "W6" ,"W7", "W9", "s20170105", "s20170032", "s20170033", "s20170035", "s20170036", "s20170037", "s20170045", "s20170046", "s20170047", "s20170048", "s20170051", "s20170052", "s20170053", "s20170057", "s20170007", "s20170076", "s20170077", "s20170078", "s20170081", "s20170123", "s20170124", "s20170125", "s20170126", "s20170127", "s20170128", "s20170129", "s20170130", "s20170132")
> type<-c("s20170005", "s20170011","s20170012", "s20170020", "s20170021" ,"s20170022", "s20170027", "s20170030", "s20170034", "s20170038", "s20170039", "s20170042", "s20170054", "s20170055", "s20170056", "s20170058", "s20170059", "s20170060", "s20170065", "s20170067", "s20170096", "s20170098", "s20170103", "s20170104", "s20170108", "s20170110", "s20170113", "s20170117", "s20170119", "s20170120", "s20170133", "s20170134", "s20170135", "W10" ,"W11" ,"W5", "W6" ,"W7", "W9", "s20170105", "s20170032", "s20170033", "s20170035", "s20170036", "s20170037", "s20170045", "s20170046", "s20170047", "s20170048", "s20170051", "s20170052", "s20170053", "s20170057", "s20170007", "s20170076", "s20170077", "s20170078", "s20170081", "s20170123", "s20170124", "s20170125", "s20170126", "s20170127", "s20170128", "s20170129", "s20170130", "s20170132")

#Prepare the table
countsTable<-read.table(file,header=T)
rownames(countsTable)<-countsTable$genes
countsTable<-countsTable[,-1] 
rlog = rlogTransformation

#####################################################
countsTable = countsTable[rowSums(countsTable)>1,]
#####################################################

#############
#COMPARE ALL#
#############
localTable<-countsTable
localCond<-cond

colData<-data.frame(condition=factor(localCond), type=factor(type))

dds<-DESeqDataSetFromMatrix(countData=localTable,colData,formula(~condition))

dds <- DESeq(dds)
rld <- rlog(dds)
#1. Plot MA to check distribution of differentially expressed genes 
plotMA(dds)

#2. Plot PCA to see sample distribution 
data <- plotPCA(rld, intgroup=c("condition"), returnData=TRUE)
percentVar <- round(100 * attr(data, "percentVar"))
ggplot(data, aes(PC1, PC2, color=condition)) + theme_bw() +
  geom_point(size=7) +
  xlab(paste0("PC1: ",percentVar[1],"% variance")) +
  ylab(paste0("PC2: ",percentVar[2],"% variance"))


#3. Get results, order them and filter by p-adj 
res <- results(dds)
res_filtered <- subset(res, res$padj < 0.05)
resOrdered <- res_filtered[order(res_filtered$padj),]
write.csv(as.data.frame(resOrdered),file=paste("results_listeria", ".csv", sep=""))


#4. Make heatmap for sample distance
sampleDists <- dist(t(assay(rld)))  
sampleDistMatrix <- as.matrix(sampleDists)
colours = colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
heatmap.2(sampleDistMatrix, trace="none", col=colours)

#5. Take 50 first DE genes and make heatmap 
select <-head(order(rowMeans(counts(dds,normalized=FALSE)),decreasing=TRUE), 50)
nt <- normTransform(dds) # defaults to log2(x+1)
log2.norm.counts <- assay(nt)[select,]
df <- as.data.frame(colData(dds)[,c("condition")])


p <-pheatmap(assay(rld)[select,], cluster_rows=FALSE, show_rownames=TRUE,cluster_cols=FALSE, annotation_col=df)
