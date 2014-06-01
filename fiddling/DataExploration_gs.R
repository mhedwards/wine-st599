
#########GS additions to Matt's exploratory analysis
pairs(redwine)
#cor(redwine[,unlist(lapply(mtcars, is.numeric))])
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

#####redo with white data set
white<-read.csv("/Users/Babydoll/Documents/BigData/wine-st599/data/whitewine-trainingset.csv", header= TRUE)

pairs(whitewine)

cor(whitewine[,unlist(lapply(whitewine, is.numeric))])
whitewine<-whitewine[,1:12]
head(whitewine)

#######pca

white.y<-whitewine$quality
head(whitewine)
white.preds<-scale(whitewine[,1:11])

pca.white<-prcomp(white.preds)
summary(pca.white)
##graph of pca
biplot(pca.white, choices = 1:2, main ="PCA of Predictor Variables")

library(ggplot2)
qplot(pca.red$x[,1],pca.red$x[,2], main="Scores of PC1 and PC2 of scaled Red Wine Data")

#looking at ordinal regression with pcs
pcr.white.5<-polr(as.factor(whitewine$quality)~pca.white$x[,1] + 
                    pca.white$x[,2]  + pca.white$x[,3] + pca.white$x[,4] + pca.white$x[,5])
pcr.white.4<-polr(as.factor(whitewine$quality)~pca.white$x[,1] + 
                    pca.white$x[,2]  + pca.white$x[,3] + pca.white$x[,4] )
pcr.white.3<-polr(as.factor(whitewine$quality)~pca.white$x[,1] + 
                    pca.white$x[,2]  + pca.white$x[,3])
pcr.white.2<-polr(as.factor(whitewine$quality)~pca.white$x[,1] + 
                    pca.white$x[,2] )
pcr.white.1<-polr(as.factor(whitewine$quality)~pca.white$x[,1])
pcr.white.6<-polr(as.factor(whitewine$quality)~pca.white$x[,1] + 
                    pca.white$x[,2]  + pca.white$x[,3] + pca.white$x[,4] + pca.white$x[,5] + + pca.white$x[,6])

summary(pcr.white.1)
summary(pcr.white.2)
summary(pcr.white.3)
summary(pcr.white.4)
summary(pcr.white.5)
summary(pcr.white.6)

AIC(pcr.white.1, pcr.white.2, pcr.white.3, pcr.white.4, pcr.white.5, pcr.white.6)
BIC(pcr.white.1, pcr.white.2, pcr.white.3, pcr.white.4, pcr.white.5, pcr.white.6)
## looks like regression with 5 pcs has lowest BIC.
## ordianl regerssion using raw data
#or.white.5<-polr(as.factor(whitewine$quality)~fixed.acidity + volatile.acidity + citric.acid + 
                   residual.sugar + chlorides + total.sulfur.dioxide + density +   pH +
                   sulphates + alcohol + free.sulfur.dioxide, data = white)

###Multinomial regression
white.test<-read.csv("/Users/Babydoll/Documents/BigData/wine-st599/data/whitewine-testset.csv", header= TRUE)
head(white.test)

if(require(MASS)) { ## dropterm, stepAIC, 
  or1 <- polr(as.factor(quality)~fixed.acidity + volatile.acidity + citric.acid + 
                residual.sugar + chlorides + total.sulfur.dioxide + density +   pH +
                sulphates + alcohol + free.sulfur.dioxide, data = white)
  dropterm(m1, test = "Chi")
  or3<- stepAIC(or1)
  summary(or3)
}
predict(or3, white[1:10,])
predict(or3,  white.test)

white.test$predict.or<-predict(or3,  newdata = white.test)
table(white.test$predict.or== white.test$quality)
## predicts at 53% not any better than MLR