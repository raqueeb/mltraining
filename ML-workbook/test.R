# Set working directory and import datafiles

setwd("~/datasets/titanic")

train <- read.csv('https://raw.githubusercontent.com/raqueeb/mltraining/master/ML-workbook/train.csv')
# train <- read.csv("~/datasets/titanic/train.csv")
# test <- read.csv("~/datasets/titanic/test.csv")
test <- read.csv('https://raw.githubusercontent.com/raqueeb/mltraining/master/ML-workbook/test.csv')

# library load, "rpart" is the decision tree 
# (rpart: Recursive Partitioning and Regression Trees)

library(rpart)

# 

model <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + 
                 Fare + Embarked, data=train, method="class")

# Now let's make a prediction and write a submission file
my_predict <- predict(model, test, type = "class")
test_df <- data.frame(PassengerId = test$PassengerId,
                  Name= test$Name, Survived = my_predict) 
