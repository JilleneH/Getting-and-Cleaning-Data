#Getting and Cleaning Data Assignment
#Requirements for run_analysis.R
#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#Load Data into a Dataframe

features <- read.table("./UCI HAR Dataset/features.txt") #List of all features
activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt") #Links the class labels with their activity name
testdatax <- read.table("./UCI HAR Dataset/test/X_test.txt") 
testdatay <- read.table("./UCI HAR Dataset/test/y_test.txt") 
testdatasubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
traindatax <- read.table("./UCI HAR Dataset/train/X_train.txt")
traindatay <- read.table("./UCI HAR Dataset/train/y_train.txt")
traindatasubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")


#Add labels to Test datasets
Testd <- cbind(testdatay, testdatasubject)
colnames(Testd) <- c("Activity", "Subject")

#Add labels to Test datasets
Traind <- cbind(traindatay, traindatasubject)
colnames(Traind) <- c("Activity", "Subject")

#Merge activity and subject columns of test and train data frames
mergedy <- rbind(Testd,Traind)

#Merge test and train
mergedx <- rbind(traindatax, testdatax)

#Apply column names from features data frame
colnames(mergedx) <- features$V2

# Step 3 - Filter out irrelevant columns
# look for mean() and std() patterns in column names
measurecol <- mergedx[, c(grep("mean()", colnames(mergedx), fixed=TRUE), grep("std()", colnames(mergedx), fixed=TRUE))]

# Add activity and subject columns to the subset data frame
combmeasurecol <- cbind(mergedy, measurecol)

# Step 4 - Find the average of each variable for each activity and each subject 
Fmean <- ddply(combmeasurecol, .(Subject, Activity), numcolwise(mean))
colnames(activitylabels) <- c("Activity", "Activity_label")

# Step 5 - Merge Fmean and activityLabels to add the activity label to Fmean data set
final <- join(Fmean, activitylabels)


#Step 6 - Write the output to a text file called tidy.txt
write.table(final, file="tidy.txt", row.names=FALSE, quote=FALSE, col.names=names(final))




