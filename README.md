GettingCleaningDataCourseProject
================================

Course Project for the Coursera Getting and Cleaning data course

Overview
========

This project serves as a demonstration of how to collect and clean data sets, such that
it can be subsequently used for analysis.
A full description of the data can be found at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The source for the data can be found at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Modification to script
======================

At the top of the file are a series of variables that can be modified to change the behaviour of the script.
There are variables indicating the paths of the data files, these are relative to the current working directory.
This means that the script does expect to be run in a certain place relative to those files.

The default is that the script is in the working directory and the following:

- Data folder is named "UCI HAR Dataset" and is in the working data.
- All of the data files are contained within the data folder above, the paths are customisable via the variables.

The output will default to being written out via write.table, however there is a PRETTY_PRINT variable which when
set to TRUE will use different methods to output the file in a nicer fashion.

The output path can be changed via the OUTPUT_PATH variable.

Running the script
==================

Once the variables are modified (or not, the defaults should work with the expected folder structure) the script
is ran by source("run_analysis.R").

Project Summary
===============

The following is a summary description of the project instructions

You should create one R script called run_analysis.R that does the following. 1. Merges the training and the test sets to create one data set. 2. Extracts only the measurements on the mean and standard deviation for each measurement. 3. Uses descriptive activity names to name the activities in the data set 4. Appropriately labels the data set with descriptive activity names. 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Additional Information
======================

You can find additional information about the variables, data and transformations in the CodeBook.MD file.