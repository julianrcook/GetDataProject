### Info about original data

Source of the original data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip .
Description of data: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

run_analysis.R merges the training and test data:

## 1. Merges the training and test sets to create one data set 

* Some notes to help understand the data:
The training files that are loaded are

```> list.files("train", pattern = "train")
[1] "subject_train.txt" "X_train.txt"       "y_train.txt" ```

There are six activities listed in y_train


```> levels(as.factor(y_train$V1))
[1] "1" "2" "3" "4" "5" "6"```

These map to the following activities Descriptions

 y_train = 1 WALKING,2 WALKING_UPSTAIRS,3 WALKING_DOWNSTAIRS,4 SITTING,5 STANDING,6 LAYING
 
There are 30 subjects (people) listed in subject_train

```> levels(as.factor(subject_train$V1))
 [1] "1"  "3"  "5"  "6"  "7"  "8"  "11" "14" "15" "16" "17" "19" "21" "22" "23" "25" "26" "27" "28"
[20] "29" "30"```

We then load the test files in the same way
The test files that are loaded are


``` > list.files("test", pattern = "test") ```
``` [1] "subject_test.txt" "X_test.txt" "y_test.txt" ```

For both sets of files the columns are all bound together using cbind, then we row  bind (rbind) the two datasets
like this

 df_train_files<-cbind(subject_train,y_train,X_train) 

 df_test_files<-cbind(subject_test,y_test,X_test) 
 df_train_and_test<-rbind(df_train_files,df_test_files) 



## 2. Reads file features.txt and extracts only the measurements on the mean and standard deviation for each measurement.

features.txt contains the colnames for the 561 measurements which at present ar called V1 V2 etc
These are read in and applied to the data frame df_train_and_test

## 3. Reads activity_labels.txt and applies descriptive activity names to name the activities in the data set:

```activity_labels <- fread("./activity_labels.txt")```

These are the activity names read from activity_labels.txt, already noted above
* walking
* walkingupstairs
* walkingdownstairs
* sitting
* standing
* laying

## 4. The script labels the data set with descriptive names: 

This is done with a merge

```df_merge_labels_data <- merge(dt_activity_labels, dt_mean_sd, by = "activity")```

where dt_activity_labels & dt_mean_sd are the activity labels and data for mean and std only

The result is saved as tidy_dataset_with_labels.csv, the data frame such that the first column contains subject IDs, the second column activity names, the third activity_id and the last 66 columns are measurements. Subject IDs are integers between 1 and 30 inclusive. 

## 5. Finally, the script creates a 2nd, independent tidy data set with the average of each measurement for each activity and each subject.

  The result is saved as tidy_dataset_with_means.txt, a 180x68 data frame, where as before, the first column contains subject IDs, the second
column contains activity names, the third column is activity_id, and then the averages for each of the 66 attributes are in columns 3...68. There are
30 subjects and 6 activities, thus 180 rows in this data set with averages.

