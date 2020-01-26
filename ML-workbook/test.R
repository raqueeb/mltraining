# setwd("~/datasets/titanic")

train <- read.csv('https://raw.githubusercontent.com/raqueeb/mltraining/master/ML-workbook/train.csv')
# train <- read.csv("~/datasets/titanic/train.csv")
# test <- read.csv("~/datasets/titanic/test.csv")
test <- read.csv('https://raw.githubusercontent.com/raqueeb/mltraining/master/ML-workbook/test.csv')

# লাইব্রেরি লোড করি - "rpart" হচ্ছে ডিসিশন ট্রি অ্যালগরিদম 
# (rpart: Recursive Partitioning and Regression Trees)

library(rpart)

# একটা মডেল তৈরি করি 

model <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + 
                 Fare + Embarked, data=train, method="class")

# একটা প্রেডিকশন ডাটাফ্রেম তৈরি করি 
my_predict <- predict(model, test, type = "class")

# সেটাকে একটা ফাইলে লেখি 
test_df <- data.frame(PassengerId = test$PassengerId,
                  Name= test$Name, Survived = my_predict) 
