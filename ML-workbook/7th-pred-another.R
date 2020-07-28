# Loading libraries
# install.packages('caret')
library(caret)
library(rpart)  
library(party)


#### Data, Preprocessing, and Feature Engineering
# load the data

setwd("/cloud/project/ML-workbook")
train <- read.csv('train.csv', header= TRUE, na.strings = c("", NA), stringsAsFactors = FALSE)
test  <- read.csv('test.csv', header= TRUE, na.strings = c("", NA), stringsAsFactors = FALSE)

test$Survived <- NA
alldata <- rbind(train,test)

# extract the title
alldata$Title <- sapply(alldata$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][2]})

# Remove the space from title
alldata$Title <- sub(' ', '', alldata$Title)

# Fix some of titles
alldata$Title[alldata$Title %in% c('Mme', 'Mlle')] <- 'Mlle'
alldata$Title[alldata$Title %in% c('Capt', 'Don', 'Major', 'Sir')] <- 'Sir'
alldata$Title[alldata$Title %in% c('Dona', 'Lady', 'the Countess', 'Jonkheer')] <- 'Lady'

# convert them to factor
alldata$Title <- factor(alldata$Title)

# Generate family size
alldata$FamilySize <- alldata$SibSp + alldata$Parch +1

# Generate surename and family ID
alldata$Surname <- sapply(alldata$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][1]})
alldata$FamilyID <- paste(as.character(alldata$FamilySize), alldata$Surname, sep="")

# We have many individual family id, this may cause problem at some prediction models. Make all of them small 
alldata$FamilyID[alldata$FamilySize <= 3] <- 'Small'
alldata$FamilyID <- factor(alldata$FamilyID)

# Imput embarking missing values
alldata$Embarked <- factor(alldata$Embarked)
alldata$Embarked[is.na(alldata$Embarked)] <- factor("S")

# Impute Age missing values
Agefit <- rpart(Age ~ Pclass + Sex + SibSp + Parch + Fare + Embarked + Title + FamilySize,
                data=alldata[!is.na(alldata$Age),],method="anova")
alldata$Age[is.na(alldata$Age)] <- predict(Agefit, alldata[is.na(alldata$Age),])

# Impute fare missing values
alldata$Fare[1044] <- median(alldata$Fare, na.rm=TRUE)

# Factorize data
alldata$Sex     <- factor(alldata$Sex)
alldata$Pclass  <- factor(alldata$Pclass)

# see what we have 
head(alldata,5)

# split data into train and test dataset
train.t <- alldata[1:891,]
test.t <- alldata[892:1309,]

# split training data into training and validation sub-sets.
set.seed(481)
train.subset.indx <- createDataPartition(train.t$Survived, p = 0.8, list=FALSE)
train.subset <- train.t[train.subset.indx,]
valid.subset <- train.t[-train.subset.indx,]

#### Prediction Model Evaluation 
# I use a very simple function to get the score for validation data set. 
modelscore <- function(test, prediction) {
  result <- test$Survived == prediction
  score <- sum(result) / length(prediction)
  return(score)
}


### RandomForest (cforest)
model.formula <- as.factor(Survived) ~ Pclass+Sex+ Age + SibSp + Parch + Fare + Embarked + Title 


cfFit <- cforest(model.formula,
                 data = train.subset, 
                 controls=cforest_unbiased(ntree=2000, mtry=3))



cfFit
# Prediction on validation data set
Pred.cf.v <- predict(cfFit,  valid.subset, OOB=TRUE, type = "response")
score.cf.v <- modelscore(valid.subset, Pred.cf.v)  # Validation: 0.8483146
score.cf.v

#save(gbmFit1, file="gbmFit1.RData")

# Prediction on test data set
Pred.cf.t <- predict(object = cfFit, newdata =test.t, OOB=TRUE, type = "response")
submit.Pred.cf.t <- data.frame(PassengerId = test.t$PassengerId, Survived = Pred.cf.t)
write.csv(submit.Pred.cf.t, file = "predCForest.csv", row.names = FALSE)
