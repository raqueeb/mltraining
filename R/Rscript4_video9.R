##########################################
# Intro to ML Traning - Statistics for R #
# Please come back here for updated file #
#       helpline: +8801713095767         #
##########################################

# Script 4 - R Video 2

# Set the working directory

setwd("~/datasets/titanic")

# Import the training set: train
# Your working directory might vary

train <- read.csv("~/datasets/titanic/train.csv")

# As row-wise proportions
prop.table(table(train$Sex,train$Survived),margin=1)
##         
##                  0         1
##   female 0.2579618 0.7420382
##   male   0.8110919 0.1889081

# As per the training data 74% females survived as opposed to 19% men

Create the column child, and indicate whether child or no child

train$Child <-0
train$Child[train$Age<18] <- 1

# Two-way comparison between Child and Adult

prop.table(table(train_data$Child,train_data$Survived),1)

##    
##             0         1
##   0 0.6388175 0.3611825
##   1 0.4601770 0.5398230
##   54% adult survived
##   only 38% child survived, even then "woman and children first"

## Lets predict on test data;

test<- read.csv("~/datasets/titanic/test.csv")

# Initialize the Survived column to 0

test$Survived <- 0

# Create the column child, and indicate whether child or no child

test$Child <-0
test$Child[test$Age < 18] <- 1

summary(train$Age)

##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    0.42   20.12   28.00   29.70   38.00   80.00     177

# Survived are set to 1 if Sex equals "female" and Child == 0

test$Survived[test$Sex =="female" & test$Child== 0] <- 1

# send the dataframe with two columns   

submit <-data.frame(test$PassengerId,test$Survived)

# naming the columns

names(submit) <- c("PassengerId","Survived")

# no rownames

rownames(submit) <- NULL

# Finally, time to submit it to Kaggle.com

write.csv(submit, file = "female_no_child.csv")

# Score 0.78469
