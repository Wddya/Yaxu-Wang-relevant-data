
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


#���ð�
library("clusterProfiler")
library("org.Hs.eg.db")
library("enrichplot")
library("ggplot2")

pvalueFilter=0.05     #pֵ��������
qvalueFilter=1       #�������pֵ��������
setwd("C:\\Users\\78570\\Desktop\\16.GO")      #���ù���Ŀ¼

#��ȡ�����ļ�
rt=read.table("corResult.txt", header=T, sep="\t", check.names=F)

#��������ת��Ϊ����id
genes=as.vector(rt[,2])
entrezIDs=mget(genes, org.Hs.egSYMBOL2EG, ifnotfound=NA)
entrezIDs=as.character(entrezIDs)
gene=entrezIDs[entrezIDs!="NA"]        #ȥ������idΪNA�Ļ���

#������ɫ����
colorSel="qvalue"
if(qvalueFilter>0.05){
	colorSel="pvalue"
}

#GO��������
kk=enrichGO(gene = gene, OrgDb = org.Hs.eg.db, pvalueCutoff =1, qvalueCutoff = 1, ont="all", readable =T)
GO=as.data.frame(kk)
GO=GO[(GO$pvalue<pvalueFilter & GO$qvalue<qvalueFilter),]
#���渻�����
write.table(GO,file="GO.txt",sep="\t",quote=F,row.names = F)

#������ʾGO��Ŀ
showNum=10
if(nrow(GO)<30){
	showNum=nrow(GO)
}

#��״ͼ
pdf(file="barplot.pdf",width = 10,height =7)
bar=barplot(kk, drop = TRUE, showCategory =showNum,split="ONTOLOGY",color = colorSel) + facet_grid(ONTOLOGY~., scale='free')
print(bar)
dev.off()
		
#����ͼ
pdf(file="bubble.pdf",width = 10,height =7)
bub=dotplot(kk,showCategory = showNum, orderBy = "GeneRatio",split="ONTOLOGY", color = colorSel) + facet_grid(ONTOLOGY~., scale='free')
print(bub)
dev.off()

