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

# Let's look at age patterns

summary(train$Age)

# We need to create another feature

train$Child <- 0

train$Child[train$Age < 18] <- 1

# Comparing more than two subsets, we need to use command "aggregate"

aggregate(Survived ~ Child + Sex, data=train, FUN=sum)

# Let's look at actually how many were they in each subset

aggregate(Survived ~ Child + Sex, data=train, FUN=length)

# comparing subsets in terms of FUN=function(x) {sum(x)/length(x)}

aggregate(Survived ~ Child + Sex, data=train, FUN=function(x) {sum(x)/length(x)}) 

# In percentage

aggregate(Survived ~ Child + Sex, data=train, FUN=function(x) {sum(x)/length(x) * 100}
