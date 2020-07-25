# Set working directory and import datafiles
# Your working directory might vary

setwd("/cloud/project/ML-workbook")
train <- read.csv("train.csv")
test <- read.csv("test.csv")

# We need to Install + load packages for decision trees and random forests

library(rpart)

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

# Mother
combined_set$Mother <- 'Not Mother'
combined_set$Mother[combined_set$Sex == 'female' & combined_set$Parch > 0 & combined_set$Age > 18] <- 'Mother'
combined_set$Mother <- factor(combined_set$Mother)

# Child

combined_set$Child[combined_set$Age < 14] <- 'Child'
combined_set$Child[combined_set$Age >= 14] <- 'Adult'
combined_set$Child <- factor(combined_set$Child)

# Cabin

combined_set$Cabin <- as.character(combined_set$Cabin)
strsplit(combined_set$Cabin[2], NULL)[[1]]
combined_set$Deck<-factor(sapply(combined_set$Cabin, function(x) strsplit(x, NULL)[[1]][1])) 

# Engineered variable: Family size
combined_set$FamilySize <- combined_set$SibSp + combined_set$Parch + 1

# Engineered variable: Family
combined_set$Surname <- sapply(combined_set$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][1]})
combined_set$FamilyID <- paste(as.character(combined_set$FamilySize), combined_set$Surname, sep="")

combined_set$FamilyID[combined_set$FamilySize <= 2] <- 'Small'
# Inspect new feature
table(combined_set$FamilyID)
# Removing all erroneous family IDs
famIDs <- data.frame(table(combined_set$FamilyID))
famIDs <- famIDs[famIDs$Freq <= 2,]
combined_set$FamilyID[combined_set$FamilyID %in% famIDs$Var1] <- 'Small'
# Convert to a factor
combined_set$FamilyID <- factor(combined_set$FamilyID)

combined_set$FamilySizeGroup[combined_set$FamilySize == 1] <- 'single'
combined_set$FamilySizeGroup[combined_set$FamilySize < 5 & combined_set$FamilySize > 1] <- 'Smaller'
combined_set$FamilySizeGroup[combined_set$FamilySize > 4] <- 'large'

# 

mosaicplot(table(combined_set$FamilySizeGroup, combined_set$Survived), main='Survival affected by Family Size ', shade=TRUE)

# Convert to a factor
combined_set$FamilyID <- factor(combined_set$FamilyID)
combined_set$FamilySizeGroup <- factor(combined_set$FamilySizeGroup)

# Fill in Age NAs
summary(combined_set$Age)

FillAge <- rpart(Age ~ Pclass + Mother + FamilySize + Sex + SibSp + Parch + Deck + Fare + Embarked + Title + FamilyID + FamilySizeGroup + FamilySize, 
                 data=combined_set[!is.na(combined_set$Age),], method="anova")
combined_set$Age[is.na(combined_set$Age)] <- predict(FillAge, combined_set[is.na(combined_set$Age),])
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

# New factor for new technique , only allowed <32 levels, so reduce number
combined_set$FamilyID2 <- combined_set$FamilyID
# Convert back to string
combined_set$FamilyID2 <- as.character(combined_set$FamilyID2)
combined_set$FamilyID2[combined_set$FamilySize <= 3] <- 'Small'
# And convert back to factor
combined_set$FamilyID2 <- factor(combined_set$FamilyID2)

#once again for both the variable
# Mother
combined_set$Mother <- 'Not Mother'
combined_set$Mother[combined_set$Sex == 'female' & combined_set$Parch > 0 & combined_set$Age > 18] <- 'Mother'
combined_set$Mother <- factor(combined_set$Mother)

# Child

combined_set$Fare_type[combined_set$Fare<50]<-"low"
combined_set$Fare_type[combined_set$Fare>50 & combined_set$Fare<=100]<-"med1"
combined_set$Fare_type[combined_set$Fare>100 & combined_set$Fare<=150]<-"med2"
combined_set$Fare_type[combined_set$Fare>150 & combined_set$Fare<=500]<-"high"
combined_set$Fare_type[combined_set$Fare>500]<-"vhigh"

aggregate(Survived~Fare_type, data=combined_set,mean) 


combined_set$Child[combined_set$Age < 14] <- 'Child'
combined_set$Child[combined_set$Age >= 14] <- 'Adult'
combined_set$Child <- factor(combined_set$Child)

# Check what else might be missing
summary(combined_set)

# Split back into test and train sets
train <- combined_set[1:891,]
test <- combined_set[892:1309,]

summary(train$Age)

summary(train)


# install.packages('randomForest')
library(randomForest)

set.seed(291)

fit <- randomForest(as.factor(Survived) ~ .,
                      data=train, 
                      importance=TRUE, 
                      ntree=2000)

fit <- randomForest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Ticket + 
                      Fare + Cabin + Mother + Surname + Child + Embarked + Title + 
                      FamilySize + FamilySizeGroup + FamilyID2,
                    data=train, 
                    importance=TRUE, 
                    ntree=2000)

# random-model <- randomForest(Survived ~ .,
                         data = predictors_no_NA,
                         importance = TRUE)

# row.has.na <- apply(train, 1, function(x){any(is.na(x))})
# predictors_no_NA <- train[!row.has.na, ]

# predictors_no_NA

anyNA(train$Fair_type)

# rftrain01 <- combined_set[1:891, c("Pclass", "Title")]

# rftrain01 <- combined_set[1:891, c("Pclass", "Title", "Mother", "FamilySize, "Sex", "SibSp",  "Parch", "Deck", "Fare", "Embarked", "Title", "FamilyID" + "FamilySizeGroup" + "FamilySize")] 



# rflabel <- as.factor(train$Survived)


# fit1 <- randomForest(x = rftrain01, y = rflabel, importance = TRUE, ntree = 1000)

fit

varImpPlot(fit)

# you can try this, I loved this - https://rpubs.com/Cornelius_Tanui/571632
