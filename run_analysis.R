

#libraries
library(reshape2)


#preparing dataset


        zippeddataDir <- "./zippeddata"
        zippeddataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        zippeddataFilename <- "zippeddata.zip"
        zippeddatardy <- paste(zippeddataDir, "/", "zippeddata.zip", sep = "")
        zippeddatadir <- "./data"



if (!file.exists(zippeddataDir)) {
 
   dir.create(zippeddataDir)
  
  download.file(url = zippeddataUrl, destfile = zippeddatardy)
   }


if (!file.exists(zippeddatadir)) {
  
  dir.create(zippeddatadir)
  
  unzip(zipfile = zippeddatardy, exdir = zippeddatadir)
   }


#2. merging training and testing data set

# refer: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


# train data


  x_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/X_train.txt"))
  y_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/Y_train.txt"))
  z_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/subject_train.txt"))

# test data
  x_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/X_test.txt"))
  y_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/Y_test.txt"))
  z_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/subject_test.txt"))

# merge {train, test} data
  x_data <- rbind(x_train, x_test)
  y_data <- rbind(y_train, y_test)
  z_data <- rbind(z_train, z_test)


#3. loading features & activities info

# feature info

    feature <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/features.txt"))

# activity labels

    a_label <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/activity_labels.txt"))
    a_label[,2] <- as.character(a_label[,2])

# extract feature cols & names named 'mean, std'

    selectedCols <- grep("-(mean|std).*", as.character(feature[,2]))
      selectedColNames <- feature[selectedCols, 2]
      selectedColNames <- gsub("-mean", "Mean", selectedColNames)
      selectedColNames <- gsub("-std", "Std", selectedColNames)
      selectedColNames <- gsub("[-()]", "", selectedColNames)


#4. extracting data by columns & using descriptive name

      x_data <- x_data[selectedCols]
    allData <- cbind(z_data, y_data, x_data)
    colnames(allData) <- c("Subject", "Activity", selectedColNames)

    allData$Activity <- factor(allData$Activity, levels = a_label[,1], labels = a_label[,2])
    allData$Subject <- as.factor(allData$Subject)


#5. generating tidy data set

    meltedData <- melt(allData, id = c("Subject", "Activity"))
    tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)

    write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)
    
    
    
    
    