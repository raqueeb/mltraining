# Set working directory and import datafiles
# Your working directory might vary
# Please message facebook.com/raqueeb for help

setwd("~/datasets/titanic")
train <- read.csv("~/datasets/titanic/train.csv")

# install.packages("Amelia")
install.packages("Amelia")
# install.packages("naniar")

# library(naniar)

# missmap function considers “NA” values as missing values but it does not 
# consider empty values as missing values.

train[train==""]<-NA
# missing.types <- c("", "NA")

# Need to see the missing data
library(Amelia)
missmap(train, main="Titanic Training Data - Missings Map", 
        col=c("yellow", "black"), legend=FALSE)

# require(Amelia)
# missmap(train, main="Titanic Training Data - Missings Map", 
        col=c("yellow", "black"), legend=FALSE)

# library(naniar)

# vis_miss(train)

# str(train)

# train[train==""]<-NA
# missing.types <- c("", "NA")

# barplot for all the variables 

# How many survived?
barplot(table(train$Survived),
        names.arg = c("Perished", "Survived"),
        main="Survived (passenger fate)", col="black")

# Passengers travelling in different classes
barplot(table(train$Pclass), 
        names.arg = c("first", "second", "third"),
        main="Pclass (passenger traveling class)", col="firebrick")

# How many survived gender-wise?
barplot(table(train$Sex), main="Sex (gender)", col="darkviolet")

# Age distribution in the Titanic
hist(train$Age, main="Age", xlab = NULL, col="brown")

# How in group people (sibling+spouse) were traveling?
barplot(table(train$SibSp), main="SibSp (siblings + spouse aboard)", col="darkblue")

# How parents and children were traveling? 
barplot(table(train$Parch), main="Parch (parents + kids aboard)", col="gray50")

# What was the fair most people paid for Titanic?
hist(train$Fare, main="Fare (fee paid for ticket[s])", xlab = NULL, col="darkgreen")

# Where most people Embarked?
barplot(table(train$Embarked), 
        names.arg = c("Cherbourg", "Queenstown", "Southampton"),
        main="Embarked (port of embarkation)", col="sienna")

# barplot(table(train$Embarked), names.arg = c("Cherbourg", "Queenstown", "Southampton"), main="Embarked (port of embarkation)", col="sienna")

# Where most people Embarked?
barplot(table(train$Embarked), names= c("Missing", "Cherbourg", "Queenstown", "Southampton"), main="Port of Embarkation")
