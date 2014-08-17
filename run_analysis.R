## Coursera coursework
##
## Getting and Cleaning data - Course Project
##
## Author : Sam Pennington
##
## Performs the following steps on the data provided in the project description.
## Full description of data:
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
## Data downloaded from:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##
##
##
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
##
## The script expects to be run in the working directory with the folder
## "UCI HAR Dataset" below it. It then expects certain files to be in that directory.
##
##
## A NOTE ON OUTPUT: The default behaviour is to use write.table as specified in the task
##                   however you can modify this by changing PRETTY_PRINT to TRUE
##                   which will change the output behaviour. Depending on the packages
##                   you have installed this can vary on nicety.
##                  

## ----------------------------------------------------------------------------
## Customisable variables.
## ----------------------------------------------------------------------------

## File paths.

OUTPUT_FILEPATH <- file.path(getwd(), 'TIDIED_DATA.txt')

DATA_FOLDER <- file.path(getwd(), "UCI HAR Dataset")

SUBJECT_TRAIN_FILE <- file.path(DATA_FOLDER, file.path("train", "subject_train.txt"))
X_TRAIN_FILE <- file.path(DATA_FOLDER, file.path("train", "x_train.txt"))
Y_TRAIN_FILE <- file.path(DATA_FOLDER, file.path("train", "y_train.txt"))

SUBJECT_TEST_FILE <- file.path(DATA_FOLDER, file.path("test", "subject_test.txt"))
X_TEST_FILE <- file.path(DATA_FOLDER, file.path("test", "x_test.txt"))
Y_TEST_FILE <- file.path(DATA_FOLDER, file.path("test", "y_test.txt"))

FEATURES_FILE <- file.path(DATA_FOLDER, "features.txt")
ACTIVITY_LABELS_FILE <- file.path(DATA_FOLDER, "activity_labels.txt")

## Column names.
SUBJECT_ID_COL <- "subjectId"
ACTIVITY_ID_COL <- "activityId"
ACTIVITY_TYPE_COL <- "activityType"

## Set whether to 'pretty print' using other means than write.table
PRETTY_PRINT <- FALSE

## ----------------------------------------------------------------------------
## Utility functions
## These are defined before usage in the script.
## ----------------------------------------------------------------------------

## Checks whether the data folder exists in the current working directory.
## Stops with an error message if it doesnt.
checkDirectory <- function() {
    if (!file.exists(DATA_FOLDER)) {
        stop(paste("Missing directory:", DATA_FOLDER, "; This is required to proceed"))
    }
    return(TRUE)
}

## If the data folder exists we switch to that as the current working directory.
changeWorkingDirectoryToDataFolder <- function() {
    if (checkDirectory()) {
        currentWD <- getwd()
        print(paste("Current working directory:", currentWD))
        setwd(DATA_FOLDER)
        print(paste("Working directory changed to:", getwd()))
    }
}

## Check if the expected files that we will be cleaning exist in the current working directory.
## If they dont we need to error out.
checkFiles <- function() {

    filenames <- c(SUBJECT_TRAIN_FILE, 
                   X_TRAIN_FILE, 
                   Y_TRAIN_FILE, 
                   SUBJECT_TEST_FILE,
                   X_TEST_FILE,
                   Y_TEST_FILE,
                   FEATURES_FILE, 
                   ACTIVITY_LABELS_FILE)

    for (i in seq_along(filenames)) {
        if (!file.exists(filenames[i])) {
            stop(paste("Missing file: ", filenames[i], "; Is your working directory correct?"))
        }
    }

    print("All required files exist.")
}

getFeaturesTable <- function() {
    return (read.table(FEATURES_FILE, header = FALSE))
}

getActivityTable <- function() {
    activityTable = read.table(ACTIVITY_LABELS_FILE, header = FALSE)
    colnames(activityTable) = c(ACTIVITY_ID_COL, ACTIVITY_TYPE_COL)
    return (activityTable)
}

mergeTrainingFiles <- function(featuresTable, activityTable) {
    ## Load the tables that we will be combining.
    subjectTrainTable = read.table(SUBJECT_TRAIN_FILE, header = FALSE)
    xTrainTable = read.table(X_TRAIN_FILE, header = FALSE)
    yTrainTable = read.table(Y_TRAIN_FILE, header = FALSE)
    ## Assign column names.
    colnames(subjectTrainTable) = SUBJECT_ID_COL
    colnames(xTrainTable) = featuresTable[, 2]
    colnames(yTrainTable) = ACTIVITY_ID_COL
    return (cbind(yTrainTable, subjectTrainTable, xTrainTable))
}

mergeTestingFiles <- function(featuresTable, activityTable) {
    ## Load the tables that we will be combining.
    subjectTestTable = read.table(SUBJECT_TEST_FILE, header = FALSE)
    xTestTable = read.table(X_TEST_FILE, header = FALSE)
    yTestTable = read.table(Y_TEST_FILE, header = FALSE)
    ## Assign names.
    colnames(subjectTestTable) = SUBJECT_ID_COL
    colnames(xTestTable) = featuresTable[,2]
    colnames(yTestTable) = ACTIVITY_ID_COL
    return (cbind(yTestTable, subjectTestTable, xTestTable))
}

## Builds a mask to enable the filtering of the merged data so that
## it only contains the columns we are interested in.
getColumnNameMask <- function() {
    ## Create a logicalVector that contains TRUE values columns with names
    ## that equate to the mean and std columns.
    ## Because the columns can have some random text before and after
    ## the tid-bit of the name we are after we are doing a grep.
    ## The OR'd groups are our individual columns, the AND terms in each group
    ## are where we are specifying our text search while eliminating some false matches.
    return ((grepl(ACTIVITY_ID_COL, finalDataColumnNames) |
             grepl(SUBJECT_ID_COL, finalDataColumnNames) |
             (grepl("-mean..", finalDataColumnNames) & !grepl("-meanFreq..", finalDataColumnNames) & !grepl("mean..-", finalDataColumnNames)) | 
             (grepl("-std..", finalDataColumnNames) & !grepl("-std()..-", finalDataColumnNames))))
}

cleanupColumnNames <- function(columnNames) {
    ## Clean up the names.
    ## Basically standardise some capitalisation and replace some
    ## shorthand naming with some full naming.
    for (i in 1:length(columnNames)) {
        columnNames[i] = gsub("\\()", "", columnNames[i])
        columnNames[i] = gsub("-std$", "StandardDeviation", columnNames[i])
        columnNames[i] = gsub("-mean", "Mean", columnNames[i])
        columnNames[i] = gsub("^(t)", "Time", columnNames[i])
        columnNames[i] = gsub("^(f)", "Frequency", columnNames[i])
        columnNames[i] = gsub("([Gg]ravity)", "Gravity", columnNames[i])
        columnNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)", "Body", columnNames[i])
        columnNames[i] = gsub("[Gg]yro", "Gyro", columnNames[i])
        columnNames[i] = gsub("AccMag", "AccelerationMagnitude", columnNames[i])
        columnNames[i] = gsub("([Bb]odyaccjerkmag)", "BodyAccelerationJerkMagnitude", columnNames[i])
        columnNames[i] = gsub("JerkMag", "JerkMagnitude", columnNames[i])
        columnNames[i] = gsub("GyroMag", "GyroMagnitude", columnNames[i])
    }
    return (columnNames)
}

## Try to output to the set filepath. If the file aready exists
## we back it up and then output.
## Note that we only keep one backup at a time.
outputFile <- function(data) {
    print (paste("Trying to output to file:", OUTPUT_FILEPATH))
    if (file.exists(OUTPUT_FILEPATH)) {
        print("File already exists, backing up and overriding.")
        if (file.exists(paste(OUTPUT_FILEPATH, ".back"))) {
            file.remove(paste(OUTPUT_FILEPATH, ".back"))
        }
        file.rename(OUTPUT_FILEPATH, paste(OUTPUT_FILEPATH, ".back"))
        print("Previous file backed up")
    }

    if (PRETTY_PRINT) {
        ## temporarily set the width for writing out the file so it
        ## doesnt get wrapped horribly.
        cachedOption <- getOption("width")
        options(width = 1500)
        if ("Hmisc" %in% rownames(installed.packages())) {
            library(Hmisc)
            capture.output(print.char.matrix(data,
                                             cell.align = "cen",
                                             col.txt.align = "cen", 
                                             col.names = TRUE, 
                                             row.names = FALSE),
                           file = OUTPUT_FILEPATH)
        } else {
            capture.output(print(data, print.gap=3), file = OUTPUT_FILEPATH)
        }
        options(width = cachedOption)
    } else {
        write.table(data, OUTPUT_FILEPATH, row.names=FALSE, sep=',');
    }
    
    print("File written.")
}

## ----------------------------------------------------------------------------
## MAIN SCRIPT EXECUTION
## ----------------------------------------------------------------------------

## Set the working directory to be that of the data folder if it exists.
checkDirectory()

## Check the files exist in the current working directory.
## Error out if they don't.
checkFiles()

## STEP 1

print("Starting STEP 1")

featuresTable = getFeaturesTable()
activityTable = getActivityTable()

print("Merging the training files.")
## Merge the subject_train, y_train and x_train files into a single set. 
mergedTraining <- mergeTrainingFiles(featuresTable, activityTable)
print("Files merged.")

print("Merging the testing files.")
## Merge the testing files (subject,x and y) into a single set.
mergedTesting <- mergeTestingFiles(featuresTable, activityTable)
print("Files merged.")

## Final action of STEP 1. Merge our testing and training sets together.
mergedFinalData = rbind(mergedTraining, mergedTesting)

## STEP 2

print("Starting STEP 2")
finalDataColumnNames = colnames(mergedFinalData)
## Create a logicalVector that contains TRUE values columns with names
## that equate to the mean and std columns.
## See the utility function for explanation of how this mask is built.
columnNameMask = getColumnNameMask()
## Filter using our mask so that we only get the desired columns.
filteredFinalData = mergedFinalData[columnNameMask == TRUE]

## STEP 3 and 4

print("Starting STEP 3 and STEP 4")

## Merge with the activity table to include descriptive names.
filteredFinalData = merge(filteredFinalData, activityTable, by = ACTIVITY_ID_COL, all.x = TRUE)
# Reassigning the new descriptive column names to the finalData set
colnames(filteredFinalData) = cleanupColumnNames(colnames(filteredFinalData));

## STEP 5

print("Starting STEP 5")
## Remove the activityType column.
absoluteFinalData = filteredFinalData[,names(filteredFinalData) != ACTIVITY_TYPE_COL]
## Summarise. 
## Only include the mean of each variable for each activity and subject.
tidied = aggregate(absoluteFinalData[,names(absoluteFinalData) != c(ACTIVITY_ID_COL, SUBJECT_ID_COL)],
                   by = list(activityId = absoluteFinalData$activityId, subjectId = absoluteFinalData$subjectId),
                   mean)
## Merge with the activity type to include descriptive activity names.
tidied = merge(tidied, activityTable, by = ACTIVITY_ID_COL, all.x = TRUE)


## Finally acutally write out the tidied data file.
outputFile(tidied)