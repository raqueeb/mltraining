#####################################
#      Intro to ML Traning - R      #
# Please come back for updated file #
#####################################

# Script 1 - Video 5

# Set the working directory

setwd("~/datasets/titanic")

# Import the training set: train
# Your working directory might vary

train <- read.csv("~/datasets/titanic/train.csv")

# viewing the "train" dataframe in raw format

train

# viewing the "train" dataframe in table format

View(train)

# Import the testing set: test

test <- read.csv("~/datasets/titanic/test.csv")

# Print test dataframe to the console

test

# view the test dataframe

View(test)

# Let's do some exploratory data analysis
# How many people in your training set survived?

table(train$Survived) 

# what is the proportions of people who survived? 

prop.table(table(train$Survived))

# how about the gender in two way comparison who survived? 

table(train$Sex, train$Survived)

# If you want to access a single column in the dataframe use $ after the dataframe
# If you want to know what is the fate of the people in the train dataset?

table(train$Survived)

# 0   1 
# 549 342 

# what about the proportion? in percentage

prop.table(table(train$Survived))

# 0         1 
# 0.6161616 0.3838384 

# Visual representation of survived in train dataset

barplot(table(train$Survived), xlab="Survived", ylab="People", main="Train Data Survival")

# Considering everyone died in test dataset, let's make our first prediction
# rep command the value 0 418 times in the newly created $Survived column

test$Survived <- rep(0, 418)

# We need to submit a csv file with the PassengerId and Survived predictions to Kaggle
# write.csv fuction writes the prediction dataframe out to a CSV file, excluding the row numbers

prediction <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
write.csv(prediction, file = "alldies.csv", row.names = FALSE)
