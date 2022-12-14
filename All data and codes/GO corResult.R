

#if (!requireNamespace("BiocManager", quietly = TRUE))
#    install.packages("BiocManager")
#BiocManager::install("limma")

#install.packages("ggplot2")
#install.packages("ggpubr")
#install.packages("ggExtra")


#引用包
library(limma)
library(ggplot2)
library(ggpubr)
library(ggExtra)
gene="FABP4"               #基因名称
corFilter=0.5             #相关系数过滤条件
pFilter=0.05           #相关性检验pvalue过滤条件
expFile="CCLEexp.txt"     #表达输入文件
setwd("C:\\Users\\78570\\Desktop\\xx")        #设置工作目录

#读取输入文件，并对输入文件进行整理
rt=read.table(expFile, header=T, sep="\t", check.names=F)
rt=as.matrix(rt)
rownames(rt)=rt[,1]
exp=rt[,2:ncol(rt)]
dimnames=list(rownames(exp), colnames(exp))
data=matrix(as.numeric(as.matrix(exp)), nrow=nrow(exp), dimnames=dimnames)
data=avereps(data)
data=data[rowMeans(data)>0.5,]

#提取目标基因表达量
x=log2(as.numeric(data[gene,])+1)
outTab=data.frame()
#对基因进行循环，进行相关性检验
for(j in rownames(data)){
	if(gene==j){next}
    y=log2(as.numeric(data[j,])+1)
	corT=cor.test(x, y, method = 'spearman')
	cor=corT$estimate
	pvalue=corT$p.value
	#保存满足条件的基因
	if((abs(cor)>corFilter) & (pvalue<pFilter)){
		outTab=rbind(outTab, cbind(Query=gene, Gene=j, cor, pvalue))
		#可视化
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

#输出相关性结果文件
write.table(file="corResult.txt", outTab, sep="\t", quote=F, row.names=F)


