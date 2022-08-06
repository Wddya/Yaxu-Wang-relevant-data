

#if (!requireNamespace("BiocManager", quietly = TRUE))
#    install.packages("BiocManager")
#BiocManager::install("limma")

#install.packages("ggplot2")
#install.packages("ggpubr")
#install.packages("ggExtra")


#���ð�
library(limma)
library(ggplot2)
library(ggpubr)
library(ggExtra)
gene="FABP4"               #��������
corFilter=0.5             #���ϵ����������
pFilter=0.05           #����Լ���pvalue��������
expFile="CCLEexp.txt"     #���������ļ�
setwd("C:\\Users\\78570\\Desktop\\xx")        #���ù���Ŀ¼

#��ȡ�����ļ������������ļ���������
rt=read.table(expFile, header=T, sep="\t", check.names=F)
rt=as.matrix(rt)
rownames(rt)=rt[,1]
exp=rt[,2:ncol(rt)]
dimnames=list(rownames(exp), colnames(exp))
data=matrix(as.numeric(as.matrix(exp)), nrow=nrow(exp), dimnames=dimnames)
data=avereps(data)
data=data[rowMeans(data)>0.5,]

#��ȡĿ����������
x=log2(as.numeric(data[gene,])+1)
outTab=data.frame()
#�Ի������ѭ������������Լ���
for(j in rownames(data)){
	if(gene==j){next}
    y=log2(as.numeric(data[j,])+1)
	corT=cor.test(x, y, method = 'spearman')
	cor=corT$estimate
	pvalue=corT$p.value
	#�������������Ļ���
	if((abs(cor)>corFilter) & (pvalue<pFilter)){
		outTab=rbind(outTab, cbind(Query=gene, Gene=j, cor, pvalue))
		#���ӻ�
		df1=as.data.frame(cbind(x,y))
		p1=ggplot(df1, aes(x, y)) + 
			xlab(paste0(gene, " expression"))+ ylab(paste0(j, " expression"))+
			geom_point()+ geom_smooth(method="lm", formula=y~x) + theme_bw()+
			stat_cor(method = 'spearman', aes(x =x, y =y))
		pdf(file=paste0("cor.", j, ".pdf"), width=5, height=4.6)
		print(p1)
		dev.off()
	}
}

#�������Խ���ļ�
write.table(file="corResult.txt", outTab, sep="\t", quote=F, row.names=F)

