# Import datafiles

train <- read.csv('https://raw.githubusercontent.com/raqueeb/mltraining/master/ML-workbook/train.csv')
test <- read.csv('https://raw.githubusercontent.com/raqueeb/mltraining/master/ML-workbook/test.csv')

# library load, "rpart" is the decision tree 
# (rpart: Recursive Partitioning and Regression Trees)
library(rpart)

# predicting our classifcation model to "model" object
model <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + 
                   Fare + Embarked, data=train, method="class")
                   
# Now let's make a prediction and dump it to a dataframe
my_predict <- predict(model, test, type = "class")
my_predict_df <- data.frame(PassengerId = test$PassengerId, Name= test$Name, Survived = my_predict) 
