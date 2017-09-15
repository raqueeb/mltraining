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

# Boxlots are best for looking into the relations between variables

boxplot(train$Age ~ train$Pclass, xlab = "Class", ylab = "Age", col = c("red"))

boxplot(train$Fare ~ train$Pclass, xlab = "Class", ylab = "Fare", col = c("red"))

# Look at class and fare patterns (more in the link)
# https://github.com/trevorstephens/titanic/blob/master/Tutorial2.R

train$Fare2 <- '30+'
train$Fare2[train$Fare < 30 & train$Fare >= 20] <- '20-30'
train$Fare2[train$Fare < 20 & train$Fare >= 10] <- '10-20'
train$Fare2[train$Fare < 10] <- '<10'

aggregate(Survived ~ Fare2 + Pclass + Sex, data=train, FUN=function(x) {sum(x)/length(x)})

# Create new column in test set with our prediction that everyone dies

test$Survived <- 0

# Update the prediction to say that all females will survive

test$Survived[test$Sex == 'female'] <- 1

# Update once more to say that females who pay more for a third class fare also perish

test$Survived[test$Sex == 'female' & test$Pclass == 3 & test$Fare >= 20] <- 0

# Create submission dataframe and output to file

submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
write.csv(submit, file = "genderclassmodel.csv", row.names = FALSE)
