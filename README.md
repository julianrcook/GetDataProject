## Getting and Cleaning Data

### The run_analysis.R script does the following:
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set.
* Appropriately labels the data set with descriptive activity names.
* Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

### To run_analysis.R:
* Set the path to the UCI HAR Dataset.
```> setwd("~R/cleandata/projectfiles/UCI_HAR_Dataset/")```
* Run run_analysis.R script.
```> source("./run_analysis.R")```

### How the run_analysis.R script works

* Loads subject_train.txt", "X_train.txt" and "y_train.txt" 
* Binds the training files together
* Loads subject_test.txt", "X_test.txt" and "y_test.txt" 
* Binds the test files together
* row binds the training and test data into one dataframe
* Merges the data with the descriptive feature labels
* Calculates the mean of each variable, aggregating over activity then subject.
* Writes the resulting summary data frame to tidy_dataset_with_means.txt.
* Write entire dataset to tidy_dataset_with_labels.csv.

