
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

#####redo with white data set
whitewine<-read.csv("/Users/Babydoll/Documents/BigData/wine-st599/data/whitewine-trainingset.csv", header= TRUE)

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
#Now look at modeling with best subset


###Reading about supervised pcr as a better prediction tool
#http://statweb.stanford.edu/~tibs/superpc/tutorial.html

featurenames <- paste("feature",as.character(1:997),sep="")
red.y<-as.numeric(red.y)
str(red.preds)
str(red.y)
data<-list(x=(red.preds,y=as.numeric(red.y), featurenames = featurenames)
data.test<-list(x=red.test[,1:11],y=as.numeric(red.test[, 12]))

# train  the model. This step just computes the  scores for each feature
superpc.train
train.obj<- superpc.train(data, type="regression")

# note for regression (non-survival) data, we leave the component "censoring.status"
# out of the data object, and call superpc.train with type="regression".
# otherwise the superpc commands are all the same



# cross-validate the model

cv.obj<-superpc.cv(train.obj, data)

#plot the cross-validation curves. From this plot we see that the 1st 
# principal component is significant and the best threshold  is around 0.7

superpc.plotcv(cv.obj)


#See pdf version of the cv plot 

# here we have the luxury of  test data, so we can compute the  likelihood ratio statistic
# over the test data and plot them. We see that the threshold of 0.7
# works pretty well
#  

lrtest.obj<-superpc.lrtest.curv(train.obj, data,data.test)

superpc.plot.lrtest(lrtest.obj)

#See pdf version of the lrtest plot


# now we derive the predictor of survival  for the test data, 
# and then then use it
# as the predictor in a Cox model . We see that the 1st supervised PC is
# highly significant; the next two are not

fit.cts<- superpc.predict(train.obj, data, data.test, threshold=0.7, n.components=3, prediction.type="continuous")


superpc.fit.to.outcome(train.obj, data.test, fit.cts$v.pred)


# sometimes a discrete (categorical) predictor is attractive.
# Here we form two groups by cutting the predictor at its median
#and then plot Kaplan-Meier curves for the two groups

fit.groups<- superpc.predict(train.obj, data, data.test, threshold=0.7, n.components=1, prediction.type="discrete")

superpc.fit.to.outcome(train.obj, data.test, fit.groups$v.pred)

plot(survfit(Surv(data.test$y,data.test$censoring.status)~fit.groups$v.pred), col=2:3, xlab="time", ylab="Prob survival")

#See pdf version of the survival plot


# Finally, we look for a predictor of survival a small number of
#genes (rather than all 1000 genes). We do this by computing an importance
# score for each equal its correlation with the supervised PC predictor.
# Then we soft threshold the importance scores, and use the shrunken
# scores as gene weights to from a reduced predictor. Cross-validation
# gives us an estimate of the best amount to shrink and an idea of
#how well the shrunken predictor works.


fit.red<- superpc.predict.red(train.obj, data, data.test, threshold=0.7)

fit.redcv<- superpc.predict.red.cv(fit.red, cv.obj,  data,  threshold=0.7)

superpc.plotred.lrtest(fit.redcv)

#See pdf version of this plot


# Finally we list the significant genes, in order of decreasing importance score

superpc.listfeatures(data.test, train.obj, fit.red, 1, shrinkage=0.17)



