Getting and Cleaning Data course project CODE BOOK
==================================================

Description
===========

Additional information about the variables, data sources and the transformations used.

Data sources
============

Full description can be found at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The data can be found at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Data set documentation
======================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

For each record it is provided:
===============================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

Units
=====

Accelerometer readings are in standard gravity units 'g'.
Gyroscope reading are in units of radians/second.

Transformations - STEP 1
========================

Read into data tables the data in the following files.
- features.txt
- activity_labels.txt
- subject_train.txt
- x_train.txt
- y_train.txt
- subject_test.txt
- x_test.txt
- y_test.txt

We assign column names and merge the first the training files and then the test files, finally merging them
both into a single data set.

Transformations - STEP 2
========================

Extract the columns that we require measurements for. Use a logical vector as a mask for the columns.

Transformations - STEP 3
========================

Merge data with activity_labels.txt data so as the garner descriptive activity names.

Transformations - STEP 4
========================

Clean up the column names so using pattern replacement. Expand on the naming of variables as well as 
standardising capitalisation.

Transformations - STEP 5
========================

Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
