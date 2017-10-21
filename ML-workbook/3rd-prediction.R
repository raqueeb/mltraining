# Need to create subsets of Fare

train$Fare2 <- '30+'
train$Fare2[train$Fare < 30 & train$Fare >= 20] <- '20-30'
train$Fare2[train$Fare < 20 & train$Fare >= 10] <- '10-20'
train$Fare2[train$Fare < 10] <- '<10'
aggregate(Survived ~ Fare2 + Pclass + Sex, data=train, FUN=function(x) {sum(x)/length(x)})

# Create new column in test set with our prediction that everyone dies
test$Survived <- 0
# Update the prediction to say that all females will survive
test$Survived[test$Sex == 'female'] <- 1
# Update once more to say that females who pay more for a third class fare also perish
test$Survived[test$Sex == 'female' & test$Pclass == 3 & test$Fare >= 20] <- 0

# send the dataframe with two columns   

3rdprediction <- data.frame (test$PassengerId, test$Survived)

# naming the columns

names (3rdprediction) <- c("PassengerId","Survived")

# no rownames

rownames (3rdprediction) <- NULL

# Finally, time to submit it to Kaggle.com

write.csv (submit, file = "prediction3.csv", row.names=FALSE)
