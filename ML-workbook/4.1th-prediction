# Set working directory and import datafiles
# Your working directory might vary

setwd("~/datasets/titanic")
train <- read.csv("~/datasets/titanic/train.csv")
test <- read.csv("~/datasets/titanic/test.csv")

# library load, "rpart" is the decision tree 
# (rpart: Recursive Partitioning and Regression Trees)
library(rpart)

# predicting our classifcation model to "model" object
model <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + 
                   Fare + Embarked, data=train, method="class")
                   
# Now let's make a prediction and dump it to a dataframe
my_predict <- predict(model, test, type = "class")
my_predict_df <- data.frame(PassengerId = test$PassengerId, Name= test$Name, Survived = my_predict) 
