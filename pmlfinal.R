training <- read.csv("~/Desktop/Practical Machine Learning/pml-training.csv",sep = ",",na.strings=c("NA","#DIV/0!",""))
testing <- read.csv("~/Desktop/Practical Machine Learning/pml-testing.csv",sep = ",",na.strings=c("NA","#DIV/0!",""))
inTrain <- createDataPartition(y=training$classe,p = 0.6,list=FALSE)
myTrain <-training[inTrain,]
myTest <- training[-inTrain,]
a <- sapply(myTrain,is.na)
b <- sapply(as.data.frame(a),sum)
c <- (b == 0)
myTrain <- myTrain[,c]
myTrain$classe <- as.factor(myTrain$classe)
library(caret)
set.seed(123)
myTrain <- myTrain[,-c(1:7)]
mod <- randomForest(classe~.,data = myTrain)
myTest <- myTest[,c]
myTest <- myTest[,-c(1:7)]
predictions <- predict(mod, myTest)
confusionMatrix(predictions,myTest$classe)
testing <- testing[,c]
testing <- testing[,-c(1:7,60)]
predictions <- predict(mod, testing)



pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}
