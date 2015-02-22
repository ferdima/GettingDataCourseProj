setwd("/Users/fernandodiazmadrigal/Documents/Coursera/Data Science/2. Getting and Cleaning Data")

data.X_test<-read.table("./data/UCI HAR Dataset/test/X_test.txt")
data.Y_test<-read.table("./data/UCI HAR Dataset/test/Y_test.txt")

data.X_train<-read.table("./data/UCI HAR Dataset/train/X_train.txt")
data.Y_train<-read.table("./data/UCI HAR Dataset/train/Y_train.txt")

labels<-read.table("./data/UCI HAR Dataset/features.txt")

subject.test<-read.table("./data/UCI HAR Dataset/test/subject_test.txt")
subject.train<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")
subject <- rbind(subject.train, subject.test)
names(subject)<-"subject"

for (i in 1:561){
  names(data.X_test)[i]<-as.character(labels[i,2])
  names(data.X_train)[i]<-as.character(labels[i,2])
  }

data.X<-rbind(data.X_train, data.X_test)
data.Y<-rbind(data.Y_train, data.Y_test)
names(data.Y)<-as.character("activity")

#Setting names to activity codes

data.Y[data.Y=="1"]<- "walking"
data.Y[data.Y=="2"]<- "walkingUp"
data.Y[data.Y=="3"]<- "walkingDown"
data.Y[data.Y=="4"]<- "sitting"
data.Y[data.Y=="5"]<- "standing"
data.Y[data.Y=="6"]<- "laying"

#Extracting columns that have "mean" or "std" in their colnames

data.mean<- data[, grep("mean", names(data))]
data.std<- data[, grep("std", names(data))]
data.lean<-cbind(subject,data.Y,data.mean, data.std)

#Now, to create the independent data.frame

subFact<-as.factor(data.lean$subject) #Factors to apply the function over
actFact<-as.factor(data.lean$activity)

datamean<-aggregate(data.lean[,-c(1,2)], list(subFact,actFact), mean)
library(dplyr)
datamean<-rename(datamean, subject = Group.1, activity = Group.2)

#Write a .txt file to upload
write.table(datamean, file="./data/tidydata.txt", row.name=FALSE)
