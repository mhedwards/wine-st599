
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
white.test$Int1<-1.945886e+02


predicted = (white.test$Int1 +(white.test$fixed.acidity*fa)+ (white.test$volatile.acidity*va)+
  (white.test$residual.sugar*resug) + (white.test$density*dens) + (white.test$pH*ph) + 
  (white.test$sulphates*sul) + (white.test$alcoho*alc)+ (white.test$free.sulfur.dioxide*fsd))
##OK now to test
## just using a blunt instrument here. I may want to look at 6-6.75 as 6 and above 6.75 as 7.
white.test$pred.mlr<-round(predicted)

sum(white.test$pred.mlr == white.test$quality)
table(white.test$pred.mlr == white.test$quality)
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
        sulphates + alcohol +free.sulfur.dioxide,data=white,model="knn",task = "c", search="heuristic")
P=predict(M,white.test) 
P
white.test$pred.knn<-round(P)

sum(white.test$pred.knn == white.test$quality)
table(white.test$pred.knn == white.test$quality)

##using k nearest neighbors got 60%
##try linear discriminate analysis got 60%
M=fit(quality~fixed.acidity+volatile.acidity +citric.acid +
        residual.sugar + chlorides +total.sulfur.dioxide + density + pH +
        sulphates + alcohol +free.sulfur.dioxide,data=white,model="lda",search="heuristic")
P=predict(M,white.test) 
P
white.test$pred.lda<-round(P)

sum(white.test$pred.lda == white.test$quality)
table(white.test$pred.lda == white.test$quality)

##try multilayer perceptron with one hidden layer got 1035 T and 805 F

M=fit(quality~fixed.acidity+volatile.acidity +citric.acid +
        residual.sugar + chlorides +total.sulfur.dioxide + density + pH +
        sulphates + alcohol +free.sulfur.dioxide,data=white,model="mlp",search="heuristic")
P=predict(M,white.test) 
P
white.test$pred.mlp<-round(P)

sum(white.test$pred.lda == white.test$quality)
table(white.test$pred.lda == white.test$quality)

## try multilayer percpetron ensemble got 1042 T and 798 F == 56%
M=fit(quality~fixed.acidity+volatile.acidity +citric.acid +
        residual.sugar + chlorides +total.sulfur.dioxide + density + pH +
        sulphates + alcohol +free.sulfur.dioxide,data=white,model="mlpe",search="heuristic")
P=predict(M,white.test) 
P
white.test$pred.mlpe<-round(P)

sum(white.test$pred.mlpe == white.test$quality)
table(white.test$pred.mlpe == white.test$quality)
##try sv got 1012 T and 828 F 
##Random forest got 1034T vs 806 F
library(randomForest)
M=fit(quality~fixed.acidity+volatile.acidity +citric.acid +
        residual.sugar + chlorides +total.sulfur.dioxide + density + pH +
        sulphates + alcohol +free.sulfur.dioxide,data=white,model="randomForest",search="heuristic")
P=predict(M,white.test) 
P
white.test$pred.randfor<-round(P)

sum(white.test$pred.randfor == white.test$quality)
table(white.test$pred.randfor == white.test$quality)

## knn wins
##SVM = 55%
M=fit(quality~fixed.acidity+volatile.acidity +citric.acid +
        residual.sugar + chlorides +total.sulfur.dioxide + density + pH +
        sulphates + alcohol +free.sulfur.dioxide,data=white,model="svm",search="heuristic")
P=predict(M,white.test) 
P
white.test$pred.svm<-round(P)

sum(white.test$pred.svm == white.test$quality)
table(white.test$pred.svm == white.test$quality)

head(white.test)
###compare to ordinal regression
if(require(MASS)) { ## dropterm, stepAIC, 
  or1 <- polr(as.factor(quality)~fixed.acidity + volatile.acidity + citric.acid + 
                residual.sugar + chlorides + total.sulfur.dioxide + density +   pH +
                sulphates + alcohol + free.sulfur.dioxide, data = white)
  dropterm(m1, test = "Chi")
  or3<- stepAIC(or1)
  summary(or3)
}
or3
predict(or3,  white[1:10,])
predict(or3,  white.test)
g<-profile(or3)
plot(g)

white.test$pred.or<-predict(or3,  newdata = white.test)
table(white.test$pred.or== white.test$quality) #981 T vs 859 F
head(white.test)
write.csv(white.test,"/Users/Babydoll/Documents/BigData/wine-st599/data/white.test.csv")
####
M=fit(quality~fixed.acidity+volatile.acidity +citric.acid +
        residual.sugar + chlorides +total.sulfur.dioxide + density + pH +
        sulphates + alcohol +free.sulfur.dioxide,data=white,model="knn",task = "r", search="heuristic10")
P=predict(M,white.test) 
P
white.test$pred.knn<-P

sum(white.test$pred.knn == white.test$quality)
table(white.test$pred.knn == white.test$quality)