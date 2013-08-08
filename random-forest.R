library(randomForest)

# To get relative paths to work, must first setwd to project root

passengers <- read.csv(paste(getwd(), "/data/train.csv", sep=""),
                       comment.char="", quote="\"", sep=",", header=TRUE, stringsAsFactors=FALSE,
                       colClasses=c("integer", "integer", "integer", "character", "character", "numeric", "integer", "integer", "character", "numeric", "character", "character"))

# Let's get some stats on the surivors & doomed
survivors.idx <- which(passengers$Survived == T)
survivors <- passengers[survivors.idx,]
doomed <- passengers[-survivors.idx,]

trainForestModel <- function(trainFrame, cols, trees=500) {
  model <- randomForest(Survived ~ ., data=trainFrame[, c("Survived", cols)], ntree=trees)
  print(model)
  return(model)
}

# TODO - what columns are important to you?
model <- trainForestModel(passengers, c())

# Load Kaggle's test data
testdata <- read.csv(paste(getwd(), "/data/test.csv", sep=""),
                     comment.char="", quote="\"", sep=",", header=TRUE, stringsAsFactors=FALSE,
                     colClasses=c("integer", "integer", "character", "character", "numeric", "integer", "integer", "character", "numeric", "character", "character"))

# And predict results
prediction <- predict(model, newdata=testdata, type="class")

# And let's write our prediction results
out.frame <- data.frame(PassengerId=testdata$PassengerId, survived=as.logical(prediction)+0)

# TODO - if there are any NAs let's assume they didn't survive for now
out.frame$survived[is.na(out.frame$survived)] <- 0

write.table(out.frame, file=paste(getwd(), "/prediction.csv", sep=""), sep=",", quote=FALSE, col.names=TRUE, row.names=FALSE)