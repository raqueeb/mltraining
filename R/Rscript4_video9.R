##########################################
# Intro to ML Traning - Statistics for R #
# Please come back here for updated file #
#       helpline: +8801713095767         #
##########################################

# Script 4 - R Video 2

# Set the working directory

setwd ("~/datasets/titanic")

# Import the training set: train
# Your working directory might vary

train <- read.csv ("~/datasets/titanic/train.csv")

# As row-wise proportions in percentages

prop.table (table(train$Sex,train$Survived), margin=1) * 100
         
##          0         1
##   female 25.79618 74.20382
##   male   81.10919 18.89081

# As per the training data 74% females survived as opposed to 19% men

## We'll create a column child, and greater than 18 is adult

train$Child <- 0
train$Child [train$Age < 18] <- 1

# Two-way comparison between Child and Adult

prop.table (table(train$Child,train$Survived), 1) * 100

##     0         1
##  0  63.88175 36.11825
##  1  46.01770 53.98230

##   54% adult survived
##   only 36% child survived, even then "woman and children first"

## Lets predict on test data;

test<- read.csv ("~/datasets/titanic/test.csv")

## test dataframe column will have child, greater than 18 is adult

test$Child <- 0
test$Child [test$Age < 18] <- 1

# Initialize the Survived column to 0

test$Survived <- 0

# Survived are set to 1 if Sex equals "female" and not Child

test$Survived [test$Sex == 'female' & test$Child == 0] <- 1
# test$Survived [test$Sex == 'female'] <- 1
# test$Survived [test$Child == 0] <- 1
## test$Survived [test$Sex == 'female' & test$Pclass == 3 & test$Fare >= 20] <-0

# send the dataframe with two columns   

submit <- data.frame (test$PassengerId, test$Survived)

# naming the columns

names (submit) <- c("PassengerId","Survived")

# no rownames

rownames (submit) <- NULL

# Finally, time to submit it to Kaggle.com

write.csv (submit, file = "female_no_child.csv", row.names=FALSE)

# Score 0.78469
