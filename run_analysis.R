library(plyr)
library(dplyr)

##read in the data (stored in the UCI HAR Dataset folder in my working directory)
features<-read.table("UCI HAR Dataset/features.txt")
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
x_test<-read.table("UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
x_train<-read.table("UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")

##Assembling the Data (step 1)
##Adding features as the variable names (step 4)
names(x_test)<-features$V2
names(x_train)<-features$V2
##adding the subject and activity variables (back to step 1)
test<-cbind(activity=as.factor(y_test$V1), x_test)
test<-cbind(subject=as.factor(subject_test$V1), test)
train<-cbind(activity=as.factor(y_train$V1), x_train)
train<-cbind(subject=as.factor(subject_train$V1), train)
##combining the datasets
total_data<-rbind(test,train)

##extracting only the measurements on the mean and standard deviation for each measurement. (step 2)
std<-grep("[sS][tT][dD]", names(total_data))
mean<-grep("[mM][eE][aA][nN]", names(total_data))
mean_std<-c(mean,std)
sort(mean_std) ##this is so I can keep the columns in their original order
extracted_data<-total_data[,c(1,2,mean_std)]

##remove excess ovjects from environment
rm(subject_test, subject_train, test, train, x_test, x_train, y_test, y_train, features, total_data, mean, std, mean_std)

##adding descriptive activity names (step 3)
extracted_data$activity<-mapvalues(extracted_data$activity, from=c("4","6","5","2","3","1"), to=levels(activity_labels$V2))
rm(activity_labels)

##creating a second tidy data set of averages (step 5)
extracted_data<-tbl_df(extracted_data)
tidy_averages<-group_by(extracted_data, subject, activity)
tidy_averages<-summarise_each(tidy_averages, funs(mean))
write.table(tidy_averages, file="tidy_data_set.txt", row.name=FALSE)

                          
