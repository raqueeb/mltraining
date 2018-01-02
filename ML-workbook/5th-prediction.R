# Set working directory and import datafiles
# Your working directory might vary

setwd("~/datasets/titanic")
train <- read.csv("~/datasets/titanic/train.csv")
test <- read.csv("~/datasets/titanic/test.csv")

# Can we see a name?
train$Name[1]

# We need to add test and train sets for feature engineering

test$Survived <- NA
combined_set <- rbind(train, test)

# Creating new variable Child and Adult

combined_set$Child[combined_set$Age < 14] <- 'Child'
combined_set$Child[combined_set$Age >= 14] <- 'Adult'

# Show counts
table(combined_set$Child, combined_set$Survived)

# Convert to a factor
combined_set$Child <- factor(combined_set$Child)

# Cabin

combined_set$Cabin <- as.character(combined_set$Cabin)
strsplit(combined_set$Cabin[2], NULL)[[1]]
combined_set$Deck<-factor(sapply(combined_set$Cabin, function(x) strsplit(x, NULL)[[1]][1])) 
                                 
# Convert to a factor
combined_set$Cabin <- factor(combined_set$Cabin)

# fare_type
                                 
combined_set$Fare_type[combined_set$Fare<50]<-"low"
combined_set$Fare_type[combined_set$Fare>50 & combined_set$Fare<=100]<-"med1"
combined_set$Fare_type[combined_set$Fare>100 & combined_set$Fare<=150]<-"med2"
combined_set$Fare_type[combined_set$Fare>150 & combined_set$Fare<=500]<-"high"
combined_set$Fare_type[combined_set$Fare>500]<-"vhigh"

aggregate(Survived~Fare_type, data=combined_set,mean) 

# Convert to a string
combined_set$Name <- as.character(combined_set$Name)

# What's in a name, again?
combined_set$Name[1]

# Find the indexes for the tile piece of the name
strsplit(combined_set$Name[1], split='[,.]')
strsplit(combined_set$Name[1], split='[,.]')[[1]]
strsplit(combined_set$Name[1], split='[,.]')[[1]][2]

# Engineered variable: Title
combined_set$Title <- strsplit(combined_set$Name, split='[,.]')[[1]][2]  # Won't work!
combined_set$Title <- sapply(combined_set$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][2]})
combined_set$Title <- sub(' ', '', combined_set$Title)

# Inspect new feature
table(combined_set$Title)

# Combined_setne small title groups
combined_set$Title[combined_set$Title %in% c('Mme', 'Mlle')] <- 'Mlle'
combined_set$Title[combined_set$Title %in% c('Capt', 'Don', 'Major', 'Sir')] <- 'Sir'
combined_set$Title[combined_set$Title %in% c('Dona', 'Lady', 'the Countess', 'Jonkheer')] <- 'Lady'

# Convert to a factor
combined_set$Title <- factor(combined_set$Title)

# Adding Mother variable

combined_set$Mother <- 'Not Mother'
combined_set$Mother[combined_set$Sex == 'female' & combined_set$Parch > 0 & combined_set$Age > 18 & combined_set$Title != 'Miss'] <- 'Mother'

# Show counts
table(combined_set$Mother, combined_set$Survived)

# Convert to a factor
combined_set$Mother <- factor(combined_set$Mother)
                                 
# Engineered variable: Family size
combined_set$FamilySize <- combined_set$SibSp + combined_set$Parch + 1

# Engineered variable: Family
combined_set$Surname <- sapply(combined_set$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][1]})
combined_set$FamilyID <- paste(as.character(combined_set$FamilySize), combined_set$Surname, sep="")

combined_set$FamilyID[combined_set$FamilySize == 1] <- 'single'
combined_set$FamilyID[combined_set$FamilySize < 5 & combined_set$FamilySize > 1] <- 'Small'
combined_set$FamilyID[combined_set$FamilySize > 4] <- 'large'

# a new plot
mosaicplot(table(combined_set$FamilySizeGroup, combined_set$Survived), main='Survival affected by Family Size ', shade=TRUE)
                                 

# Inspect new feature
table(combined_set$FamilyID)

# Convert to a factor
combined_set$FamilyID <- factor(combined_set$FamilyID)

# Split back into test and train sets
train <- combined_set[1:891,]
test <- combined_set[892:1309,]
                                
# Install and load required packages for fancy decision tree plotting

install.packages('rpart')
install.packages('rpart.plot')
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)

# Build a new tree with our new features
fit <- rpart(Survived ~ Pclass + Sex + Age + Mother + SibSp + Parch + Deck + Fare + Embarked + Title + FamilySize + FamilyID,
             data=train, method="class")

fancyRpartPlot(fit)

# Now let's make a prediction and write a submission file
prediction_5th <- predict(fit, test, type = "class")
submit <- data.frame(PassengerId = test$PassengerId, Survived = prediction_5th)
write.csv(submit, file = "prediction5th.csv", row.names = FALSE)
