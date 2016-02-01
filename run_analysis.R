## Clear workspace
rm(list=ls())

## Initialize
fileTrainx <- "./data/train/X_train.txt"
fileTrainy <- "./data/train/y_train.txt"
fileTrainSubjects <- "./data/train/subject_train.txt"
fileTestx <- "./data/test/X_test.txt"
fileTesty <- "./data/test/y_test.txt"
fileTestSubjects <- "./data/test/subject_test.txt"
fileFeatures <- "./data/features.txt"
fileActivity <- "./data/activity_labels.txt"

## Read all the datafiles
dataTrainx <- read.csv(fileTrainx,header = FALSE,sep="",dec=".",fill=TRUE)
dataTrainy <- read.csv(fileTrainy,header = FALSE,sep="",dec=".",fill=TRUE)
dataTrainSubjects <- read.csv(fileTrainSubjects,header = FALSE,sep="",dec=".",fill=TRUE)
dataTestx <- read.csv(fileTestx,header = FALSE,sep="",dec=".",fill=TRUE)
dataTesty <- read.csv(fileTesty,header = FALSE,sep="",dec=".",fill=TRUE)
dataTestSubjects <- read.csv(fileTestSubjects,header = FALSE,sep="",dec=".",fill=TRUE)
dataFeatures <- read.csv(fileFeatures,header = FALSE,sep="",dec=".",fill=TRUE)

## Combine the datafiles into one dataset
dataTrain <- data.frame(dataTrainSubjects,dataTrainy,dataTrainx)
dataTest <- data.frame(dataTestSubjects,dataTesty,dataTestx)
data <- rbind(dataTrain,dataTest)
names(data)[1:2] <- c("Subject","Movement") 
names(data)[3:dim(data)[2]] <- as.character(dataFeatures[,2])

## Extract measurements on mean and standard
columnsMS <- c(1,2,grep("mean|std",names(data)))
dataMS <- data[,columnsMS]

## Name the activity
dataActivity <- read.csv(fileActivity,header = FALSE,sep="",dec=".",fill=TRUE)
dataMS$Movement <- factor(dataMS$Movement,levels=dataActivity[,1],labels=dataActivity[,2])

## Average of each variable for each activity and each subject
#dataList <- split(dataMS,list(dataMS$Subject,dataMS$Movement))
dataTidy <- aggregate(dataMS[,3:dim(dataMS)[2]],list(dataMS$Subject,dataMS$Movement),mean)
write.table(dataTidy,file="dataTidy.txt",row.name=FALSE)
