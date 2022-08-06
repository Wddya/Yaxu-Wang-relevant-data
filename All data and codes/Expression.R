

#if (!requireNamespace("BiocManager", quietly = TRUE))
#    install.packages("BiocManager")
#BiocManager::install("limma")

#install.packages("ggplot2")
#install.packages("ggpubr")


#���ð�
library(limma)
library(ggplot2)
library(ggpubr)
expFile="symbol.txt"     #���������ļ�
gene="AKAP12"              #���������
setwd("C:\\Users\\78570\\Desktop\\122geneImmune\\07.diff")     #���ù���Ŀ¼

#��ȡ��������ļ�,�������ݽ��д���
rt=read.table(expFile, header=T, sep="\t", check.names=F)
rt=as.matrix(rt)
rownames(rt)=rt[,1]
exp=rt[,2:ncol(rt)]
dimnames=list(rownames(exp),colnames(exp))
data=matrix(as.numeric(as.matrix(exp)), nrow=nrow(exp), dimnames=dimnames)
data=avereps(data)
data=t(data[gene,,drop=F])

#������������Ŀ
group=sapply(strsplit(rownames(data),"\\-"), "[", 4)
group=sapply(strsplit(group,""), "[", 1)
group=gsub("2", "1", group)
conNum=length(group[group==1])       #��������Ʒ��Ŀ
treatNum=length(group[group==0])     #��������Ʒ��Ŀ
Type=c(rep(1,conNum), rep(2,treatNum))

#�������
exp=cbind(data, Type)
exp=as.data.frame(exp)
colnames(exp)=c("gene", "Type")
exp$Type=ifelse(exp$Type==1, "Normal", "Tumor")
exp$gene=log2(exp$gene+1)

#���ñȽ���
group=levels(factor(exp$Type))
exp$Type=factor(exp$Type, levels=group)
comp=combn(group,2)
my_comparisons=list()
for(i in 1:ncol(comp)){my_comparisons[[i]]<-comp[,i]}

#����boxplot
boxplot=ggboxplot(exp, x="Type", y="gene", color="Type",
		          xlab="",
		          ylab=paste0(gene, " expression"),
		          legend.title="Type",
		          palette = c("deepskyblue","mediumvioletred"),
		          add = "jitter")+ 
	stat_compare_means(comparisons=my_comparisons,symnum.args=list(cutpoints = c(0, 0.001, 0.01, 0.05, 1), symbols = c("***", "**", "*", "ns")),label = "p.signif")

#���ͼƬ
pdf(file=paste0(gene,".diff.pdf"), width=5, height=4.5)
print(boxplot)
dev.off()

