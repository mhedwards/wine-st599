
#########GS additions to Matt's exploratory analysis
pairs(redwine)

cor(redwine[,unlist(lapply(mtcars, is.numeric))])
## highly collinear variables will be problematic. 
## one idea is to do principle component ordinal regression.
##Basically doing ordinal regression with the PC's of a pca to get the variables
#orthogonal and eliminat multicollinearity.


#######pca

red.y<-redwine.trainingset$quality
head(redwine.trainingset)
red.preds<-redwine.trainingset[,1:11]

pca.red<-prcomp(red.preds, scale = TRUE)
summary(pca.red)
##graph of pca
biplot(pca.red, choices = 1:2, main ="PCA of Predictor Variables")

library(ggplot2)
qplot(pca.red$x[,1],pca.red$x[,2], main="Scores of PC1 and PC2 of scaled Red Wine Data")

#looking at ordinal regression with pcs
pcr.red.5<-polr(as.factor(redwine.trainingset$quality)~pca.red$x[,1] + 
                  pca.red$x[,2]  + pca.red$x[,3] + pca.red$x[,4] + pca.red$x[,5])
pcr.red.4<-polr(as.factor(redwine.trainingset$quality)~pca.red$x[,1] + 
                  pca.red$x[,2]  + pca.red$x[,3] + pca.red$x[,4])
pcr.red.3<-polr(as.factor(redwine.trainingset$quality)~pca.red$x[,1] + 
                  pca.red$x[,2]  + pca.red$x[,3])
pcr.red.2<-polr(as.factor(redwine.trainingset$quality)~pca.red$x[,1] + 
                  pca.red$x[,2])
pcr.red.1<-polr(as.factor(redwine.trainingset$quality)~pca.red$x[,1] )
summary(pcr.red.1)
summary(pcr.red.2)
summary(pcr.red.3)
summary(pcr.red.4)
summary(pcr.red.5)

##lowest AIC/BIC looks like pcr with 3 pc's ## This may be a start.
AIC(pcr.red.1, pcr.red.2, pcr.red.3, pcr.red.4, pcr.red.5)
BIC(pcr.red.1, pcr.red.2, pcr.red.3, pcr.red.4, pcr.red.5)
