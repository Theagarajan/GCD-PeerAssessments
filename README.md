# Peer Assessments

## Files
 - README.md: the current file
 - run_analysis.R: the program to perform the analysis and generate the tidy data set
 - tidyData.txt: the generated tidy data set in CSV format
 - CodeBook.md: the tidyData.txt variables documentation
 - getdata-projectfiles-UCI HAR Dataset.zip: initial raw data.
 
## Presentation
In this program, we use the 'sqldf' and 'data.table' libraries.
The code starts by cleaning the allocated objects in the user workspace.

The steps performed are the following:
- Load the data and create a single data frame for the training data set.
- Load the data and create a single data frame for the test data set.
- Merge the training and test data frames.
- Extract the measurements on mean and standard deviation. We search for the words 'mean' or 'std' in each measurement labels to create a list of correct features.
After, we take a subset of the initial data frame using the list of corrects features.
- Create a tidy data set with the average of each variable for each activity an each subject.
- Save to file the tidy data table in CSV format.
