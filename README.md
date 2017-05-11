# Getting and Cleaning Data - Course Project

This is the readme file for the run_analysis.R program. This program performs the following tasks:
<br><br>
1.) Downloading the required dataset and unzipping it 
<br><br>
2.) Loading the activity and feature infos as well as the two datasets (train and test)
<br><br>
3.) Merges the train and the test dataset with the subjectIDs and the trainingIDs and merged all those data together in one dataset
<br><br>
4.) Only the variables that contain informations about mean values or standard deviations are extracted and converted into another dataset
<br><br>
5.) In this dataset it creates a column with activity labels according to the values of the activityID
<br><br>
6.) The variable names get converted into a readable and understandable format
<br><br>
7.) from this dataset a new dataset is created which aggregates the measurement data so that every subject has corresponding mean values of every variable depending on the activity.
<br><br>
8.) it writes the new dataset into a file called tidydata.txt
