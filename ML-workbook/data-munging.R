# Set working directory and import datafiles
# Your working directory might vary

setwd("~/datasets/titanic")
train <- read.csv("~/datasets/titanic/train.csv")

# install.packages("Amelia")
# install.packages("Amelia")

library(Amelia)
missmap(train, main="Titanic Training Data - Missings Map", 
        col=c("yellow", "black"), legend=FALSE)

# barplot for all the variables 

barplot(table(train$Survived),
        names.arg = c("Perished", "Survived"),
        main="Survived (passenger fate)", col="black")
barplot(table(train$Pclass), 
        names.arg = c("first", "second", "third"),
        main="Pclass (passenger traveling class)", col="firebrick")
barplot(table(train$Sex), main="Sex (gender)", col="darkviolet")
hist(train$Age, main="Age", xlab = NULL, col="brown")
barplot(table(train$SibSp), main="SibSp (siblings + spouse aboard)", 
        col="darkblue")
barplot(table(train$Parch), main="Parch (parents + kids aboard)", 
        col="gray50")
hist(train$Fare, main="Fare (fee paid for ticket[s])", xlab = NULL, 
     col="darkgreen")
barplot(table(train$Embarked), 
        names.arg = c("Cherbourg", "Queenstown", "Southampton"),
        main="Embarked (port of embarkation)", col="sienna")

# barplot(table(train$Embarked), names.arg = c("Cherbourg", "Queenstown", "Southampton"), main="Embarked (port of embarkation)", col="sienna")

# barplot(table(train$Embarked), names= c("Missing", "Cherbourg", "Queenstown", "Southampton"), main="Port of Embarkation")
