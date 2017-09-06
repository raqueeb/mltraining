##########################################
# Intro to ML Traning - Statistics for R #
# Please come back here for updated file #
#       helpline: +8801713095767         #
##########################################

# Script 5 - R Video 10

# Set the working directory

setwd ("~/datasets/titanic")

# Import the training set: train
# Your working directory might vary

train <- read.csv ("~/datasets/titanic/train.csv")

# Look at age patterns

summary(train$Age)

train$Child <- 0

train$Child[train$Age < 18] <- 1

aggregate(Survived ~ Child + Sex, data=train, FUN=sum)

aggregate(Survived ~ Child + Sex, data=train, FUN=length)

aggregate(Survived ~ Child + Sex, data=train, FUN=function(x) {sum(x)/length(x)}) 

aggregate(Survived ~ Child + Sex, data=train, FUN=function(x) {sum(x)/length(x)}) * 100
