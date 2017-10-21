# Set the working directory

setwd ("~/datasets/titanic")

# Import the training set: train
# Your working directory might vary

train <- read.csv ("~/datasets/titanic/train.csv")

# Need to create subsets of Fare

train$Fare2 <- '30+'
train$Fare2[train$Fare < 30 & train$Fare >= 20] <- '20-30'
train$Fare2[train$Fare < 20 & train$Fare >= 10] <- '10-20'
train$Fare2[train$Fare < 10] <- '<10'

# Comparing more than two subsets, we need to use command "aggregate"

aggregate(Survived ~ Fare2 + Pclass + Sex, data=train, FUN=sum)

# Let's look at actually how many were they in each subset

aggregate(Survived ~ Fare2 + Pclass + Sex, data=train, FUN=length)

# comparing subsets in terms of FUN=function(x) {sum(x)/length(x)}

aggregate(Survived ~ Fare2 + Pclass + Sex, data=train, FUN=function(x) {sum(x)/length(x)}) 

# In percentage

aggregate(Survived ~ Fare2 + Pclass + Sex, data=train, FUN=function(x) {sum(x)/length(x) * 100}

aggregate(Survived ~ Fare2 + Pclass + Sex, data=train, FUN=function(x) {sum(x)/length(x)})

# Create new column in test set with our prediction that everyone dies
test$Survived <- 0
# Update the prediction to say that all females will survive
test$Survived[test$Sex == 'female'] <- 1
# Update once more to say that females who pay more for a third class fare also perish
test$Survived[test$Sex == 'female' & test$Pclass == 3 & test$Fare >= 20] <- 0

# send the dataframe with two columns   

prediction3rd <- data.frame (test$PassengerId, test$Survived)

# naming the columns

names (prediction3rd) <- c("PassengerId","Survived")

# no rownames

rownames (prediction3rd) <- NULL

# Finally, time to submit it to Kaggle.com

write.csv (prediction3rd, file = "prediction3.csv", row.names=FALSE)
