# Set working directory and import datafiles
# Your working directory might vary

setwd("~/datasets/titanic")
train <- read.csv("~/datasets/titanic/train.csv")
test <- read.csv("~/datasets/titanic/test.csv")

# Install and load required packages for fancy decision tree plotting

install.packages('rattle')
install.packages('rpart.plot')
install.packages('RColorBrewer')
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)

# Recreate the gender model

mytree1 <- rpart(Survived ~ Sex, data=train, method="class")
fancyRpartPlot(mytree1)

mytree2 <- rpart(Survived ~ Pclass + Age, data=train, method="class")
fancyRpartPlot(mytree2)

# Build a deeper tree
mytree3 <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=train, method="class")
# Plot it with base-R
plot(mytree3)
text(mytree3)
# And then make it look better with fancyRpartPlot!
fancyRpartPlot(mytree3)

# Now let's make a prediction and write a submission file
prediction4th <- predict(mytree3, test, type = "class")
prediction4 <- data.frame(PassengerId = test$PassengerId, Survived = prediction4th)
write.csv(prediction4, file = "tree1.csv", row.names = FALSE)
