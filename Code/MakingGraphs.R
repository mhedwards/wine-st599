#Making Graphs
library(dplyr)
library(ggplot2)

OSU.orange <- rgb(243/255,115/255,33/255)
OSU.dkblue <- rgb(93/255,135/255,161/255)
OSU.ltblue<- rgb(156/255,197/255,202/255)

## Regression


white.reg <- tbl_df(read.csv("data/white.test.csv", header=T, stringsAsFactors=F))
white.reg

knn.res <- white.reg%.%select(quality, pred.knn)%.%mutate(match=(quality==pred.knn))
or.res <- white.reg%.%select(quality, pred.or)%.%mutate(match=(quality==pred.or))

# K nearest neighbor regression
sum(knn.res$match)/nrow(knn.res) # 59.6%

ggplot(data=knn.res, aes(factor(pred.knn), fill=match))+geom_bar(aes(order=desc(match)), width=0.5)+coord_flip()+xlab("Quality 'Prediction'")+ylab("Count")+theme_bw(18)+ggtitle("K Nearest Neighbors Regression")+scale_fill_manual(values=c("TRUE"=OSU.orange, "FALSE"=OSU.ltblue))

ggsave("images/KNNRegression_Results.pdf", width=8, height=4)

## Ordinal REgression
sum(or.res$match)/nrow(knn.res) # 53.3%

ggplot(data=or.res, aes(factor(pred.or), fill=match))+geom_bar(aes(order=desc(match)), width=0.5)+coord_flip()+xlab("Quality 'Prediction'")+ylab("Count")+theme_bw(18)+ggtitle("Ordinal Regression")+scale_fill_manual(values=c("TRUE"=OSU.orange, "FALSE"=OSU.ltblue))

ggsave("images/OrdinalRegression_Results.pdf", width=8, height=4)


## Translated into table in presentation.
knn.res %.% group_by(pred.knn) %.% summarise(n=n(), true=sum(match), false=n-true, pct.true = true/n, pct.false=false/n)
or.res %.% group_by(pred.or) %.% summarise(n=n(), true=sum(match), false=n-true, pct.true = true/n, pct.false=false/n)
