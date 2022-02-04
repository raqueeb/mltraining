# দুটো ভ্যারিয়েবল অর্থাৎ ডেটাফ্রেম তৈরি করি, টেস্ট এবং ট্রেনিং 

train <- read.csv('https://raw.githubusercontent.com/raqueeb/mltraining/master/ML-workbook/train.csv')
test <- read.csv('https://raw.githubusercontent.com/raqueeb/mltraining/master/ML-workbook/test.csv')

# ডিসিশন ট্রি লাইব্রেরি, "rpart" চালু করে নেই 
# (rpart: Recursive Partitioning and Regression Trees)

library(rpart)

# ক্লাসিফিকেশন মডেল প্রেডিকশন, মডেল অবজেক্টে পাঠিয়ে

# model <- rpart(survived ~ ., data = train, method = 'class')

model <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + 
                   Fare + Embarked, data=train, method="class")
                   
# প্রেডিকশন তৈরি, মডেল, টেস্ট ডেটাফ্রেম, বাইনারি ক্লাসিফিকেশন   

my_predict <- predict(model, test, type = "class")

# ডেটাফ্রেম তৈরি, আইডি, নাম, এবং উনি বেঁচে গিয়েছিলেন কিনা জানতে
my_predict_df <- data.frame(PassengerId = test$PassengerId, Name= test$Name, Survived = my_predict)

# মেশিন লার্নিং কিভাবে সিদ্ধান্ত নিলো, সেটার ভিজ্যুয়ালাইজেশন - স্টেপ বাই স্টেপ

library(rpart.plot)
rpart.plot(fit, extra = 106)
