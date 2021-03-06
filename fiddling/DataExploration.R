### Code Exploration & Clean up
library(sampling)
library(dplyr)
library(MASS)
# The original files were in *.csv format, but were actually delimited with semi colons ; instead of commas. Opened files in Excel, and convered to actual Comma delimited files. These are the "winequality-red-new" and "winequality-white-new" files.

redwine <- read.csv("data/winequality-red-new.csv", header=T, stringsAsFactors=F)
nrow(redwine) #1599 rows of data

whitewine <- read.csv("data/winequality-white-new.csv", header=T, stringsAsFactors=F)
nrow(whitewine) #4898 rows of data.

library(ggplot2)
ggplot()+geom_bar(data=whitewine, aes(factor(quality)), fill="white", color="black")+xlab("Quality")+ylab("Count")+theme_bw(18)+
  geom_text(data=whitewine,stat="bin", aes(factor(quality), y=..count..+75, label=..count..))

ggplot()+geom_bar(data=whitewine, aes(factor(quality)), fill=rgb(243/255,115/255,33/255))+xlab("Quality")+ylab("Count")+theme_bw(18)+
  geom_text(data=whitewine,stat="bin", aes(factor(quality), y=..count..+75, label=..count..))

ggsave("images/white_hist.pdf", width=6, height=4)


# ----- REd Wine -----
red.q <- redwine$quality
hist(red.q)
quantile(red.q, seq=c(0, .25, .5, .75, 1))
# min is 3, max is 8
# 0%  25%  50%  75% 100% 
# 3    5    6    6    8 

table(red.q)
# 3   4   5   6   7   8 
# 10  53 681 638 199  18
# we will need to do some sort of stratified sampling to make sure we have all the fields represented.

red.n <- c(10,53,681,638,199,18)
red.size <- ceiling(red.n*(600/1600)) # take a little more than 1/3 of observations. round up to whole #'s

# stratified sample 
s=strata(redwine[order(redwine$quality),], c("quality"), size=red.size, method="srswor" )
redwine.samp <- getdata(redwine[order(redwine$quality),],s) # gives you the rows IN the sample, but can't get the rows NOT in sample

redwine.sort <- tbl_df(redwine[order(redwine$quality),])
redwine.sort$row_id <- seq(1:nrow(redwine))

samp_ids <- s$ID_unit

filter(redwine.sort, row_id %in% samp_ids)
head(redwine.samp)
# these give me the same results as getdata(). The redwine.samp has extra colums for stratum # and inclusion probability, but i don't think we need those right now.
#   what we DO need, is the ability to get the rows NOT in the sample, which "getdata" doesn't seem to allow. 

# break up into our two sets.
red.samp <- filter(redwine.sort, row_id %in% samp_ids) # 602
red.training <- filter(redwine.sort, !row_id %in% samp_ids)  #997
# 602+997=1599
head(red.training)
# save to files.
write.csv(red.samp, "data/redwine-testset.csv", row.names=FALSE )
write.csv(red.training, "data/redwine-trainingset.csv", row.names=FALSE)


# ----- White Wine -----
white.q <- whitewine$quality
hist(white.q)
quantile(white.q, seq=c(0, .25, .5, .75, 1))
# 0%  25%  50%  75% 100% 
# 3    5    6    6    9 
table(white.q)
# 3    4    5    6    7    8    9 
# 20  163 1457 2198  880  175    5 

# still clusterd around 5/6, min is 3 but max is 9 (very few)
white.n <- c(20,163,1457,2198,880,175,5)

white.n*600/1600
#   7.500  61.125 546.375 824.250 330.000  65.625   1.875
white.n*900/4898
# 3.6749694  29.9510004 267.7215190 403.8791343 161.6986525  32.1559820   0.9187423
4898*600/1600
#[1] 1836.75  # going to go with the same proportion as the redwine so we have 2 of the 9's in the testing set. 
# this still leaves us about 3,000 samples to train on.

# get sample sizes
white.size <- ceiling(white.n*600/1600)

# sort & add row #'s to original data (strata() requires data sorted by strata)
white.sort <- tbl_df(whitewine[order(whitewine$quality),])
white.sort$row_id <- seq(1:nrow(whitewine))

# do the stratified sampling
w <- strata(white.sort, c("quality"), size=white.size, method="srswor" )
samp_id.w <- w$ID_unit

# break up original data into our two sets
white.samp <- filter(white.sort, row_id %in% samp_id.w) # 1840 obs
white.train <- filter(white.sort, !row_id %in% samp_id.w) # 3058 obs
# 1840+3058 = 4898

# write to file.
write.csv(white.samp, "data/whitewine-testset.csv", row.names=FALSE )
write.csv(white.train, "data/whitewine-trainingset.csv", row.names=FALSE)

# --- Combined Graph to Save ---
par(mfrow=c(2,1))
hist(red.q, xlim=c(0,10), main="Red Wine: Quality", xlab="Quality")
hist(white.q, xlim=c(0,10), main="White Wine: Quality", xlab="Quality")

#########GS additions to Matt's exploratory analysis
pairs(redwine)

cor(redwine[,unlist(lapply(mtcars, is.numeric))])
## highly collinear variables will be problematic. 
## one idea is to do principle component ordinal regression.
##Basically doing ordinal regression with the PC's of a pca to get the variables
#orthogonal and eliminat multicollinearity.


#######pca
redwine.trainingset <- read.csv("data/redwine-trainingset.csv", header=T, stringsAsFactors=F)
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

# This makes sense why you selected PCA- multivariate responses..

