# Import the training set: train
# Your working directory might vary

setwd("~/datasets/titanic")
train <- read.csv("~/datasets/titanic/train.csv")

install.packages('rattle')
install.packages('rpart.plot')
install.packages('RColorBrewer')

library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)

mytree1 <- rpart(Survived ~ Sex, data=train, method="class")
fancyRpartPlot(mytree1)
mytree2 <- rpart(Survived ~ Pclass + Age, data=train, method="class")
fancyRpartPlot(mytree2)

