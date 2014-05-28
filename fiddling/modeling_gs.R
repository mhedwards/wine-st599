
white<-read.csv("/Users/Babydoll/Documents/BigData/wine-st599/data/whitewine-trainingset.csv", header = TRUE)
#Now look at modeling with 

install.packages("ordinal")
library("ordinal")
## need to scale the predictors
#white.y<-white$quality
#head(white)

#white.x<-scale(white[,1:11])

#wwscale<-as.data.frame(cbind(white.y, white.x))
#head(wwscale)
if(require(MASS)) { ## dropterm, stepAIC, 
  m1 <- lm(white$quality~fixed.acidity + volatile.acidity + citric.acid + 
              residual.sugar + chlorides + total.sulfur.dioxide + density +   pH +
              sulphates + alcohol + free.sulfur.dioxide, data = white)
  dropterm(m1, test = "Chi")
  m3 <- stepAIC(m1)
  summary(m3)
}
m3$coef

means<-apply(white, 2, mean)
sds<-apply(white, 2, sd)


fa<-1.045317e-01
va<--1.950710e+00
resug<-9.420111e-02 
dens<--1.952274e+02
ph<-8.837933e-01       
sul<-6.237002e-01       
alc<-1.307144e-01
fsd<-2.248178e-03
m3$coef
white.test<-read.csv("/Users/Babydoll/Documents/BigData/wine-st599/data/whitewine-testset.csv", header = TRUE)
white.test$Int<-1.945886e+02


predicted = (white.test$Int +(white.test$fixed.acidity*fa)+ (white.test$volatile.acidity*va)+
  (white.test$residual.sugar*resug) + (white.test$density*dens) + (white.test$pH*ph) + 
  (white.test$sulphates*sul) + (white.test$alcoho*alc)+ (white.test$free.sulfur.dioxide*fsd))
##OK now to test
## just using a blunt instrument here. I may want to look at 6-6.75 as 6 and above 6.75 as 7.
white.test$predict<-round(predicted)

sum(white.test$predict == white.test$quality)
table(white.test$predict == white.test$quality)
##53% prediction == not so great


