##### RAndom Categorization
library(dplyr)
library(ggplot2)

white.train <- read.csv("data/whitewine-trainingset.csv", header=T, stringsAsFactors=F)

qual <- white.train$quality

table(qual)
N <- nrow(white.train)
w.sum <- white.train %.% group_by(quality) %.% filter(quality  %in% c(5,6) )%.% summarise(n=n(), p = n/N)
#The proportions of 5 and 6's do not add up to 1, it's actually about 75% of observations are a 5 or a 6
.29758+.448986 ## 74.6566


# Get scaling factor
delta <- 1/sum(w.sum$p)

delta*w.sum$p
#[1] 0.3985983 0.6014017

# There is a 60.14 % chance of being a 6, and a 39.86% chance of being a 5.

white.test <- read.csv("data/whitewine-testset.csv", header=T, stringsAsFactors=F)
nsim <- nrow(white.test)
# 1840

# Generate random vector indicating quality is "predicted" to be a 6
sixes <- rbinom(nsim, 1, delta*w.sum$p[2])
# add 5 to get vector of 5s & 6s & add to data frame.
quality.hat <- sixes+5
white.test$quality.hat <- quality.hat
head(white.test)

# add true/false field to see if "prediction" was correct
white.test <- white.test %.% mutate(match=(quality==quality.hat))

write.csv(white.test, "data/results-random-assignment.csv", row.names=F)

sum(white.test$match)
# 730

sum(white.test$match)/nrow(white.test)
# 39.67% Success rate.

ggplot(data=white.test, aes(factor(quality.hat), fill=match))+geom_bar(aes(order=desc(match)), width=0.5)+coord_flip()+xlab("Quality 'Prediction'")+ylab("Count")+theme_bw(18)+ggtitle("Totally Random Prediction")

ggsave("images/RandomPrediction.pdf", width=8, height=4)
