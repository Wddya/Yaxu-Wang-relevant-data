
#install.packages("colorspace")
#install.packages("stringi")
#install.packages("ggplot2")

#if (!requireNamespace("BiocManager", quietly = TRUE))
#    install.packages("BiocManager")
#BiocManager::install("org.Hs.eg.db")
#BiocManager::install("DOSE")
#BiocManager::install("clusterProfiler")
#BiocManager::install("enrichplot")
#BiocManager::install("pathview")


#引用包
library("clusterProfiler")
library("org.Hs.eg.db")
library("enrichplot")
library("ggplot2")

pvalueFilter=0.05     #p值过滤条件
qvalueFilter=1       #矫正后的p值过滤条件
setwd("C:\\Users\\78570\\Desktop\\16.GO")      #设置工作目录

#读取输入文件
rt=read.table("corResult.txt", header=T, sep="\t", check.names=F)

#基因名字转换为基因id
genes=as.vector(rt[,2])
entrezIDs=mget(genes, org.Hs.egSYMBOL2EG, ifnotfound=NA)
entrezIDs=as.character(entrezIDs)
gene=entrezIDs[entrezIDs!="NA"]        #去除基因id为NA的基因

#定义颜色类型
colorSel="qvalue"
if(qvalueFilter>0.05){
	colorSel="pvalue"
}

#GO富集分析
kk=enrichGO(gene = gene, OrgDb = org.Hs.eg.db, pvalueCutoff =1, qvalueCutoff = 1, ont="all", readable =T)
GO=as.data.frame(kk)
GO=GO[(GO$pvalue<pvalueFilter & GO$qvalue<qvalueFilter),]
#保存富集结果
write.table(GO,file="GO.txt",sep="\t",quote=F,row.names = F)

#定义显示GO数目
showNum=10
if(nrow(GO)<30){
	showNum=nrow(GO)
}

#柱状图
pdf(file="barplot.pdf",width = 10,height =7)
bar=barplot(kk, drop = TRUE, showCategory =showNum,split="ONTOLOGY",color = colorSel) + facet_grid(ONTOLOGY~., scale='free')
print(bar)
dev.off()
		
#气泡图
pdf(file="bubble.pdf",width = 10,height =7)
bub=dotplot(kk,showCategory = showNum, orderBy = "GeneRatio",split="ONTOLOGY", color = colorSel) + facet_grid(ONTOLOGY~., scale='free')
print(bub)
dev.off()


