# Run Analysis performs cleanup, merging of training and test files
# and addition of descriptive column names to the cellphone test data
# Then it calculates averages by = subject,activity

# Comment this out if data is elsewhere
setwd("~/R/cleandata/projectfiles/UCI_HAR_Dataset/")
# Assume that you have already set your working directory to
# setwd("~/R/cleandata/projectfiles/UCI_HAR_Dataset/") before starting script
# Using List.files will return the following three files in the training dir
# list.files("train", pattern = "train")
#[1] "subject_train.txt" "X_train.txt"       "y_train.txt" 
# These are the files we open and combine followed by the /test data

# Data.table functions are used for most operations
library("data.table", lib.loc="~/R/win-library/3.1")

# Use fread from data.table
subject_train<-fread("train/subject_train.txt")
# For some reason fread() fails on X_train, so used read.table
X_train<-read.table("train/X_train.txt")
y_train<-fread("train/y_train.txt")

# subject_train.txt': Each row identifies the subject who performed the activity (1-30)

# df_train_files is the data frame with all the training columns bound together
df_train_files<-cbind(subject_train,y_train,X_train)
subject_test<-fread("test/subject_test.txt")
X_test<-read.table("test/X_test.txt")
y_test<-fread("test/y_test.txt")

# df_test_files is the data frame with all the test columns bound together
df_test_files<-cbind(subject_test,y_test,X_test)

# The two data frames are joined row wise
df_train_and_test<-rbind(df_train_files,df_test_files)

# features.txt contains the colnames for the 561 measurements which at present ar called V1 V2 etc
feature_names<-fread("./features.txt")

colnames(feature_names)<-c("id", "labels")

# descriptive_names looks like this. They will be the col names for df_train_and_test
# [1] "subject"           "activity"          "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z"
[6] "tBodyAcc-std()-X" etc
descriptive_names <- c("subject", "activity", as.character(feature_names$labels))
default_names<-colnames(df_train_and_test)
setnames(df_train_and_test,default_names,default_names)

# To search for any columns that compute mean or STD grep for 'mean' and 'std' patterns
# Then join them to the subject & activity column names
features_mean_std <- grep("mean\\(|std\\(", feature_names$labels, value=T)
df_mean_std <- df_train_and_test[, c("subject", "activity", features_mean_std)]

activity_labels <- fread("./activity_labels.txt")

colnames(activity_labels)<-c("activity_num", "labels")

# Convert the data frames to data.table types for quicker merge
dt_activity_labels<-data.table(activity_labels)
dt_mean_sd<-data.table(df_mean_sd)
# synch the col headers and make them the data.table keys
colnames(activity_labels)<-c("activity", "labels")
setkey(dt_activity_labels, "activity")
colnames(dt_activity_labels)<-c("activity", "labels")
setkey(dt_activity_labels, "activity")

# The actual Tidy data set
df_merge_labels_data <- merge(dt_activity_labels, dt_mean_sd, by = "activity")

# Move onto next part that compute means
# Creates a second, independent tidy data set with the average of each variable by activity & subject

# clean up the col names by removing the brackets
test_names<-gsub("\\(","",features_mean_std)
test_names<-gsub("\\)","",test_names)
# Get rid of labels for now, because it will not summarize [it is a char column]
df_merge_labels_data$labels<-NULL

# Summarize , meaning compute means by subject,activity using data.table
dt_mean_sum<-df_merge_labels_data[,lapply(.SD, mean),by="subject,activity"]
# Test_sum actually aggregates by subj,activity

# add back the descripitive labels as a column
dt_remerge_labels_means <- merge(dt_activity_labels, dt_mean_sum)
write.csv(df_merge_labels_data, "tidy_dataset_with_labels.csv", row.names = F)
# I used write.table here because forum advised us to do so
write.table(dt_remerge_labels_means, "tidy_dataset_with_means.txt", row.names = F)
