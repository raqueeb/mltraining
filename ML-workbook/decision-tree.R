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

round(prop.table(table(train$Survived)),2)
## 
##    0    1 
## 0.62 0.38
round(prop.table(table(train$Sex, train$Survived),margin = 1),2)
##         
##             0    1
##   female 0.26 0.74
##   male   0.81 0.19

mytree2 <- rpart(Survived ~ Pclass + Age, data=train, method="class")
fancyRpartPlot(mytree2)
