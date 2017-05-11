## 1.1: files are downloaded, unzipped and loaded into R. the matching
## variables get labelled for later merging

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
setwd("./data/UCI HAR Dataset")

features <- read.table("features.txt")
activity_lables <- read.table("activity_labels.txt")
colnames(activity_lables) <- c("activityID", "activityType")

subject_test <- read.table("./test/subject_test.txt", col.names="subjectID")
x_test <- read.table("./test/X_test.txt",
                     col.names=features$V2, check.names=FALSE)
y_test <- read.table("./test/y_test.txt", col.names="activityID")

subject_train <- read.table("./train/subject_train.txt", col.names="subjectID")
x_train <- read.table("./train/X_train.txt",
                      col.names=features$V2,check.names=FALSE)
y_train <- read.table("./train/y_train.txt", col.names="activityID")


## 1.2.: here the subject-ids, the activities and the measurement data are
##merged together.

merged_test <- cbind(subject_test, y_test, x_test)
merged_train <- cbind(subject_train, y_train, x_train)
all_merged <- rbind(merged_test, merged_train)


## 2.: in the next step, only the columns that contain either "mean" or
## "std" in their namelabel are converted into a new data frame

meanandstd <- all_merged[,grepl("subjectID|activityID|[Mm]ean|[Ss]td",
                                names(all_merged))]

## 3.: here the values of the activityID column are replaced with the
## according activity labels

library(dplyr)
dfactivitynames <- merge(activity_lables, meanandstd,
                         by.x="activityID", all.x=TRUE)

## 4.: Now the variable names are replaced according to the features_info
## textfile.
dflabels <- names(dfactivitynames)

dflabels <- sub("^f", "frequency domain signal:", dflabels)
dflabels <- sub("^t", "time domain signal:", dflabels)
dflabels <- sub("std\\(\\)", "standard deviation", dflabels)
dflabels <- sub("[Mm]ean\\(\\)", "mean value", dflabels)
dflabels <- sub("meanFreq\\(\\)", "mean frequency", dflabels)
dflabels <- sub("Mag", " magnitude", dflabels)
dflabels <- sub("Acc", " acceleration", dflabels)
dflabels <- sub("accelerationJerk", " acceleration jerk", dflabels)
dflabels <- sub("Gyro", " gyroscopic velocity", dflabels)
dflabels <- sub("GyroJerk", " gyroscopic jerk", dflabels)
dflabels <- sub("VelocityJerk", "velocity jerk", dflabels)
dflabels <- gsub("Body", " body", dflabels)
dflabels <- sub("-X", " in X direction", dflabels)
dflabels <- sub("-Y", " in Y direction", dflabels)
dflabels <- sub("-Z", " in Z direction", dflabels)
dflabels <- sub("-", " - ", dflabels)

names(dfactivitynames) <- dflabels

## 5.: In the last step a new dataset is created by aggregating the
## measurement data so that every subject has its mean values of the
## measured variables of every corresponding activity. 

seconddataset <- aggregate(. ~subjectID + activityID, dfactivitynames, mean)
seconddataset <- seconddataset[order(seconddataset$subjectID, seconddataset$activityID),]
seconddataset <- merge(activity_lables, seconddataset,
                       by="activityID")
seconddataset$activityType.y <- NULL
seconddataset <- rename(seconddataset, activitytype = activityType.x)

write.table(seconddataset, file = "tidydata.txt", row.name=FALSE)

