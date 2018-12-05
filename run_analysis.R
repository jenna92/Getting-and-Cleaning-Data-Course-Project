
#set the working directory
setwd("./UCI HAR Dataset")

# read features
features <- read.csv("features.txt",header = FALSE, sep =" ")
feaures <- as.character(features[,2])

#read the train dataset
data_train_x <- read.table("./train/X_train.txt")
data_train_activity <- read.csv("./train/y_train.txt",header = FALSE,sep = " ")
data_train_subject <- read.csv("./train/subject_train.txt", header=FALSE,sep = " ")
data_train <- data.frame(data_train_subject,data_train_activity,data_train_x)
dim(data_train)
feature <- features[,2]
feature <- as.character(feature)
names(data_train) <- c(c('subject', 'activity'),feature)
#read the test dataset
data_test_subject <- read.table("./test/subject_test.txt")
data_test_activity <- read.csv("./test/y_test.txt",header = FALSE,sep=" ")
data_test <- data.frame(data_test_subject,data_test_activity,data_test_x)
names(data_test) <- c(c("subject","activity"),feature)

#combine the train and test dataset together
data_all <- rbind(data_train,data_test)

#Extracts only the measurements on the mean and standard deviation for each measurement.
data_mean_std <- grep("mean|std",feature)
data_mean_std <- data_all[,c(1,2,data_mean_std+2)]

#Uses descriptive activity names to name the activities in the data set
activity <- read.csv("activity_labels.txt",header=FALSE,sep=" ")
activity <- as.character(activity[,2])
data_mean_std$activity <- activity[data_mean_std$activity] 

#Appropriately labels the data set with descriptive variable names.
new_names <- names(data_mean_std)
new_names <- gsub("[(][)]","",new_names)
new_names <- gsub("-mean-","_mean_",new_names)
new_names<- gsub("^t","TimeDomain_",new_names)
new_names<- gsub("^f","FrequencyDomain_",new_names)
new_names <- gsub("Acc","Accelerometer",new_names)
new_names <- gsub("Gyro","Gyroscope",new_names)
new_names <- gsub("Mag","Magnitude",new_names)
new_names <- gsub("-","_",new_names)
new_names <- gsub("std","standardDeviation",new_names)
names(data_mean_std) <- new_names

#creates a tidy data set with the average of each variable for each activity and each subject.
data_tidy <- aggregate(data_mean_std[,3:81],
by = list(subject = data_mean_std$subject,activity=data_mean_std$activity), FUN = mean)
write.table(x = data_tidy, file = "data_tidy.txt", row.names = FALSE)