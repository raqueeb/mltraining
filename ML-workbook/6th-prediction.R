# Set working directory and import datafiles
# Your working directory might vary

setwd("~/datasets/titanic")
train <- read.csv("~/datasets/titanic/train.csv")
test <- read.csv("~/datasets/titanic/test.csv")

# We need to Install + load packages for decision trees and random forests

library(rpart)
install.packages('randomForest')
library(randomForest)
install.packages('party')
library(party)

# Join together the test and train sets for easier feature engineering
test$Survived <- NA
combined_set <- rbind(train, test)

# Convert to a string
combined_set$Name <- as.character(combined_set$Name)

# Engineered variable: Title
combined_set$Title <- sapply(combined_set$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][2]})
combined_set$Title <- sub(' ', '', combined_set$Title)
# Combine small title groups
combined_set$Title[combined_set$Title %in% c('Mme', 'Mlle')] <- 'Mlle'
combined_set$Title[combined_set$Title %in% c('Capt', 'Don', 'Major', 'Sir')] <- 'Sir'
combined_set$Title[combined_set$Title %in% c('Dona', 'Lady', 'the Countess', 'Jonkheer')] <- 'Lady'
# Convert to a factor
combined_set$Title <- factor(combined_set$Title)

# Engineered variable: Family size
combined_set$FamilySize <- combined_set$SibSp + combined_set$Parch + 1

# Engineered variable: Family
combined_set$Surname <- sapply(combined_set$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][1]})
combined_set$FamilyID <- paste(as.character(combined_set$FamilySize), combined_set$Surname, sep="")
combined_set$FamilyID[combined_set$FamilySize <= 2] <- 'Small'
# Delete erroneous family IDs
famIDs <- data.frame(table(combined_set$FamilyID))
famIDs <- famIDs[famIDs$Freq <= 2,]
combined_set$FamilyID[combined_set$FamilyID %in% famIDs$Var1] <- 'Small'
# Convert to a factor
combined_set$FamilyID <- factor(combined_set$FamilyID)

# Fill in Age NAs
summary(combined_set$Age)

FillAge <- rpart(Age ~ Pclass + Mother + FamilySize + Sex + SibSp + Parch + Deck + Fare + Embarked + Title + FamilyID + FamilySize, 
                data=combined_set[!is.na(combined_set$Age),], method="anova")
combined_set$Age[is.na(combined_set$Age)] <- predict(FillAge, combined_set[is.na(combined_set$Age),])
summary(combined_set)

# Check what else might be missing
summary(combined_set)
# Fill in Embarked blanks
summary(combined_set$Embarked)
which(combined_set$Embarked == '')
combined_set$Embarked[c(62,830)] = "S"
combined_set$Embarked <- factor(combined_set$Embarked)
# Fill in Fare NAs
summary(combined_set$Fare)
which(is.na(combined_set$Fare))
combined_set$Fare[1044] <- median(combined_set$Fare, na.rm=TRUE)

# New factor for Random Forests, only allowed <32 levels, so reduce number
combined_set$FamilyID2 <- combined_set$FamilyID
# Convert back to string
combined_set$FamilyID2 <- as.character(combined_set$FamilyID2)
combined_set$FamilyID2[combined_set$FamilySize <= 3] <- 'Small'
# And convert back to factor
combined_set$FamilyID2 <- factor(combined_set$FamilyID2)

# Split back into test and train sets
train <- combined_set[1:891,]
test <- combined_set[892:1309,]

# Build Random Forest Ensemble
set.seed(415)
fit <- randomForest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID2,
                    data=train, importance=TRUE, ntree=2000)
# Look at variable importance
varImpPlot(fit)
# Now let's make a prediction and write a submission file
Prediction <- predict(fit, test)
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)
write.csv(submit, file = "firstforest.csv", row.names = FALSE)

# Build condition inference tree Random Forest
set.seed(415)
fit <- cforest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID,
               data = train, controls=cforest_unbiased(ntree=2000, mtry=3)) 
# Now let's make a prediction and write a submission file
Prediction <- predict(fit, test, OOB=TRUE, type = "response")
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)
write.csv(submit, file = "ciforest.csv", row.names = FALSE)
