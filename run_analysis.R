# Clean the workspace
rm(list = ls())

# Useful libraries
library(sqldf)
library(data.table)

activity_labels <- read.csv("./UCI HAR Dataset/activity_labels.txt", sep =  "", header = FALSE)
names(activity_labels) <- c("Activity", "Activity_Label")
features <- read.csv("./UCI HAR Dataset/features.txt", sep =  "", header = FALSE, stringsAsFactors = FALSE)
names(features) <- c("Feature", "Feature_Label")

## *****************************************************************
## Load data an create a single data frame for the training data set
## *****************************************************************
x_train <- read.csv("./UCI HAR Dataset/train/X_train.txt", sep =  "", header = FALSE)
names(x_train) <- features$Feature_Label

# Load training labels data set and join the activity labels
y_train <- read.csv("./UCI HAR Dataset/train/y_train.txt", sep =  "", header = FALSE)
names(y_train) <- c("Activity")
y_train <- sqldf("select * from y_train left join activity_labels using (Activity)")

# Load subjects data set
subject_train <- read.csv("./UCI HAR Dataset/train/subject_train.txt", sep =  "", header = FALSE)
names(subject_train) <- c("Subject")

# Merge the frames the training labels and the training data sets
data_train <- cbind(subject_train, y_train, x_train)

## *************************************************************
## Load data an create a single data frame for the test data set
## *************************************************************
x_test <- read.csv("./UCI HAR Dataset/test/X_test.txt", sep =  "", header = FALSE)
names(x_test) <- features$Feature_Label

# Load training labels data set  and join the activity labels
y_test <- read.csv("./UCI HAR Dataset/test/y_test.txt", sep =  "", header = FALSE)
names(y_test) <- c("Activity")
y_test <- sqldf("select * from y_test left join activity_labels using (Activity)")

# Load subjects data set
subject_test <- read.csv("./UCI HAR Dataset/test/subject_test.txt", sep =  "", header = FALSE)
names(subject_test) <- c("Subject")

# Merge the frames the training labels and the training data sets
data_test <- cbind(subject_test, y_test, x_test)

## *****************************************************************
## Merge the test and training data sets and perform memory cleaning
## *****************************************************************
data <- rbind(data_train, data_test)
toRemove <- c("x_train", "y_train", "subject_train", "x_test", "y_test", "subject_test", "data_train", "data_test")
rm(list = toRemove)

## **********************************************************
## Extract only the measurements on the mean and the standard
## deviation for each mesurement
## **********************************************************
goodCols <- grepl("mean|std", features$Feature_Label)
goodLabels <- features$Feature_Label[goodCols]
newData <- subset(data[, 4:564], select = as.factor(goodLabels))
names(newData) <- goodLabels
newData <- cbind(data[,1:3], newData)
head(newData)
tail(newData)

## **************************************************************
## Create a second, independent tidy data set with the average of
## each variable for each activity and each subject
## **************************************************************
dataTable <- data.table(newData)
tidyData <- dataTable[, lapply(.SD, mean), by=c("Subject", "Activity_Label"), .SDcols=goodLabels]
head(tidyData)
tail(tidyData)

## **********************************************
## Create the tidy data output file in csv format
## **********************************************
write.csv(tidyData, "./tidyData.txt", row.names = FALSE)
