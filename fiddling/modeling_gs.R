
white<-read.csv("/Users/Babydoll/Documents/BigData/wine-st599/data/whitewine-trainingset.csv", header = TRUE)
#Now look at modeling with 

install.packages("ordinal")
library("ordinal")
## need to scale the predictors
white.y<-whit$quality
head(white)
white.preds<-scale(white[,1:11])

wwscale<-as.data.frame(cbind(white.y, white.preds))
head(wwscale)
if(require(MASS)) { ## dropterm, stepAIC, 
  m1 <- clm(as.factor(white.y)~fixed.acidity + volatile.acidity + citric.acid + 
              residual.sugar + chlorides + total.sulfur.dioxide + density +   pH +
              sulphates + alcohol + free.sulfur.dioxide, data = wwscale)
  dropterm(m1, test = "Chi")
  m3 <- stepAIC(m1)
  summary(m3)
}
head(m3$model)
head(ww)
##built model now need to test on rest of data frame