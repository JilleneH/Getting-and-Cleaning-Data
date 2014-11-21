---
title: "README"
author: "JH"
---
This readme file contains information about run_analysis.R.  
Here's a summary of the funtionality of run_anlysis.R

#Requirements for run_analysis.R
#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The data comes from the following link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Additional information can be found from this link:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

This dataset comes from the Machine Learning Repository at UCI.  The data contains information from 30 volunteers who wore smartphone (Samsung Galaxy S II) on their waist.  The data measures the following activities, Walking, Walking Upstairs, Walking Downstairs, Sitting, Standing, and Laying.  The run_analysis.r program merges the datasets (train & test), attaches the labels, & creates a tidy dataset with the averages of the variables.


#Load Data into a Dataframe.  This programs assumes the UDCI HAR Dataset is located in the working directory.

features <- read.table("./UCI HAR Dataset/features.txt") #List of all features
activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt") #Links the class labels with their activity name
testdatax <- read.table("./UCI HAR Dataset/test/X_test.txt") 
testdatay <- read.table("./UCI HAR Dataset/test/y_test.txt") 
testdatasubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
traindatax <- read.table("./UCI HAR Dataset/train/X_train.txt")
traindatay <- read.table("./UCI HAR Dataset/train/y_train.txt")
traindatasubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")


#Add labels to test datasets
testd <- cbind(testdatay, testdatasubject)
colnames(testd) <- c("Activity", "Subject")

#Add labels to train datasets
traind <- cbind(traindatay, traindatasubject)
colnames(traind) <- c("Activity", "Subject")

#Merge activity and subject columns of test and train data frames
mergedy <- rbind(testd,traind)

#Merge test and train
mergedx <- rbind(traindatax, testdatax)

#Apply column names from features data frame
colnames(mergedx) <- features$V2


#Capture mean and standard deviation columns
measurecol <- mergedx[, c(grep("mean()", colnames(mergedx), fixed=TRUE), grep("std()", colnames(mergedx), fixed=TRUE))]

# Add activity and subject columns to the subset data frame
combmeasurecol <- cbind(mergedy, measurecol)

#Find the average of each variable for each activity and each subject 
finalmean <- ddply(combmeasurecol, .(Subject, Activity), numcolwise(mean))
colnames(activitylabels) <- c("Activity", "Activity_label")

#Merge finalmean and activitylabels to add the activity label to finalmean data set
final <- join(finalmean, activitylabels)


#Create an output called tidy.txt.  This data contains the average of each variable 
write.table(final, file="tidy.txt", row.names=FALSE, quote=FALSE, col.names=names(final))




