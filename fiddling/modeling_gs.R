
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
#
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

##trying other model selection techniques
library(leaps)
?regsubsets
tmp<-regsubsets(white$quality~fixed.acidity+volatile.acidity +citric.acid +
                  residual.sugar + chlorides +total.sulfur.dioxide + density + pH +
                  sulphates + alcohol +free.sulfur.dioxide, data = white, really.big = T)
tmp.s<-summary(tmp)
tmp.s$bic

cbind(tmp.s$which, tmp.s$bic)

tmp1<-lm(quality~alcohol, data = white)
summary(tmp1)
predict(white.test)
white.test$Int<-2.61143


predicted = (white.test$Int +(white.test$alcohol*.31081))
##OK now to test
## just using a blunt instrument here. I may want to look at 6-6.75 as 6 and above 6.75 as 7.
white.test$predict<-round(predicted)

sum(white.test$predict == white.test$quality)
table(white.test$predict == white.test$quality)
### model with only alcohol gets ~49%

###OK now try forward selection
null=lm(quality~1, data=white)
full=lm(quality~fixed.acidity + volatile.acidity + citric.acid + 
          residual.sugar + chlorides + total.sulfur.dioxide + density +   pH +
          sulphates + alcohol + free.sulfur.dioxide, data=white)
step(null, scope=list(lower=null, upper=full), direction="forward")
step(full, direction="backward")
step(null, scope=list(lower=null, upper=full), direction="both")
##get same model with forward and stepwise, but not backward
lm8<-lm(quality~fixed.acidity + volatile.acidity  + residual.sugar + density +   pH +
          sulphates + alcohol + free.sulfur.dioxide, data = white)
summary(lm8)
##same model as via forward, backward, stepwise and regsubsets

head(white)
pairs(white[,1:5,12])
pairs(white[,6:12])

####using Rminer package

### regression example
library(rminer)

M=fit(quality~fixed.acidity+volatile.acidity +citric.acid +
        residual.sugar + chlorides +total.sulfur.dioxide + density + pH +
        sulphates + alcohol +free.sulfur.dioxide,data=white,model="knn",search="heuristic")
P=predict(M,white.test) # P should be negative...
P
white.test$predict1<-round(P)

sum(white.test$predict1 == white.test$quality)
table(white.test$predict1 == white.test$quality)
##using k nearest neighbors got 60%
M=fit(quality~fixed.acidity+volatile.acidity +citric.acid +
        residual.sugar + chlorides +total.sulfur.dioxide + density + pH +
        sulphates + alcohol +free.sulfur.dioxide,data=white,model="knn",search="heuristic")
P=predict(M,white.test) # P should be negative...
P
white.test$predict1<-round(P)

sum(white.test$predict1 == white.test$quality)
table(white.test$predict1 == white.test$quality)
##got same
##try linear discriminate analysis
M=fit(quality~fixed.acidity+volatile.acidity +citric.acid +
        residual.sugar + chlorides +total.sulfur.dioxide + density + pH +
        sulphates + alcohol +free.sulfur.dioxide,data=white,model="lda",search="heuristic")
P=predict(M,white.test) 
P
white.test$predict1<-round(P)

sum(white.test$predict1 == white.test$quality)
table(white.test$predict1 == white.test$quality)

##try naive got 825 T and 1015 F (BAD!!)
##try dt 935 T and 905 F
##try multilayer perceptron with one hidden layer got 1035 T and 805 F
## try multilayer percpetron ensemble got 1042 T and 798 F == 57%
##try sv got 1012 T and 828 F same as randomForest



install.packages("mda")
library(mda)
M=fit(quality~fixed.acidity+volatile.acidity +citric.acid +
        residual.sugar + chlorides +total.sulfur.dioxide + density + pH +
        sulphates + alcohol +free.sulfur.dioxide,data=white,model="randomForest",search="heuristic")
P=predict(M,white.test) # P should be negative...

white.test$predict1<-round(P)

sum(white.test$predict1 == white.test$quality)
table(white.test$predict1 == white.test$quality)

## knn wins
