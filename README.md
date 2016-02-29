# README tidydata
This is my submission for the final assignment of Getting and Cleaning data. This repository includes the following files:
* tiny_data_set.txt - tidy data created by the script that can be read into R with read.table("tiny_data_set.txt", header=TRUE) so long as the file is in your working directory.
* run_analysis.R - R script that reads in data from the UCI HAR Dataset folder (which can be accessed by extracting the zip file avaiable [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). Once the UCI HAR Dataset folder has been placed in your working directory, you can run the script `source("run_analysis.R")` to produce two data objects in your environment (the merged data and the tidy) and output tiny_data_set.text to your working directory.
* CODEBOOK.md - defines the variable names
* README.md - this file explains the script, how it works, and why I made certain choices.

## Step 1
At the beginning of the script I loaded plyr and dplyr as I would use a function from each package towards the end of my script. I also make sure that the UCI HAR Dataset folder is in my working directory (in other words when you open that folder you see the readme and other files).

The next step is I read all the relevant files as data objects. I pulled in all the files except for the readme, the feature information, and the inertial signals. At this point I could see the sizes of each object and realize how they should fit togther.

1. I labeled the column names using the second column from the feature file. This was what was asked for in step 4, but I did it now, because it was easier to add it at this point when the feature name vector was the same size as the number of columns. I do this for both the test and training datasets.
2. I used cbind to add the y (activity column) and the subject column as factors to the front of the data frame. The column names are added as activity and subject accordingly. I do this for both the test and training datasets.
3. Now I merge the data sets by rbinding the training set below the test set. I chose rbind because both datasets had all of the same columns. I call this object total_data.
## Step 2
1. To extract only the data involving standard deviation or mean, I created two vectors of the values where the terms mean or std appear in the column names. I wanted to be sure to grab all instances regardless of capitalization so I added regex either/or pattern (ie [Ss] to the grep function. I then run grep through the column names (using `names(total_data)`) to find the location for each query (mean and std).
2. Now I have two vectors, one with the location of column names that include mean and the other with the location of column names with std. I want a single vector with all this data, so I add the two together. using `c(mean, std)`. I call this new vector mean_std.
3. I want to maintain the original order of the columns so I reorder my vector using sort.
4. I can now use my vector to subset by column number. I want to be sure to still see subject and activity to I subset by `c(1,2,mean_std)` since columns 1 and 2 are my subject and my activity variables. I store my extracted data in extracted_data.
5. At this point, I thought it would be nice to remove all the extra objects I'd created along the way from the Environment, so I use the `rm()` function. 

## Step 3
1. Since I added my activity column as a factor, I thought this would be easy to do, using plyr's `mapvalues` function to overwrite the number factors with the second column I read in from the activity labels file. However, everything I tried relabled the numbers (1,2,3,etc) with the wrong corresponding activity. Looking at the second columns of the activity_labels object again, I saw that the factors were not in numeric order. I couldn't find a quick way to refactor and since I was only dealing with 6 factor levels, I just changed my from vector to match the order of the activity labels.
2. At this point I no longer need the activity_labels object so I removed that as well.

## Step 4
I did this at the beginning of step 1 when I changed the column names to match the features.

## Step 5
1. I converted the data frame for use with dplyr
2. Then i used the group_by function to create groups for subjects and activities. I assigned this to a new object, tidy_averages.
3. Now I could run the mean function on the whole table with summarise_each. I assigned this new table to be tidy_averages.
4. Finally I wrote the file to "tidy_data_set.txt"

Not knowing the question to be answered, I left my data in the wide format, since from this point it could be most easily manipulated to answer questions I had looking at the data. For example, you can easily from this point subset by activity or by user to take closer looks at the data.
