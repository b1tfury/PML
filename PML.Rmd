---
title: "Final Project Report"
output: html_document
---
This is the Coursera Practical Macihine Learning Course Project which is the part of Data Science Specialization by Johns Hopkins Bloomberg School of Public Health.

The following is being produced , tested and executed on Ubuntu 14.04 LTS  and Rstudio Version 0.98.1091.

Devloper :- Sahil Kharb

GitHub repo :-  https://github.com/sahil28/PML

RPubs :- http://rpubs.com/sahil28/pml

## Background Introduction

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, my goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information is available from the website here: http://groupware.les.inf.puc-rio.br/har (see the section on the Weight Lifting Exercise Dataset). 

## Data Sources

Training data :- https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv

Testing Data :- https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv

Source: http://groupware.les.inf.puc-rio.br/har. 

If you use this document for any purpose please cite them as they have been very generous in allowing their data to be used for this kind of assignment. 

## Project Goal

The goal of this project is to predict the manner in which they did the exercise. This is the "classe" variable in the training set.

We will also use your prediction model to predict 20 different test cases. 

## Analysis 

```{r}
library(caret)
library(randomForest)
```

Finally load some seed wih libraries.
```{r}
set.seed(123)
```

## Getting the data

I have downloaded the data files on my laptop so I wil load it from there itself you can use 'url' function to directly download from web

```{r}
training <- read.csv("~/coursera/Practical Machine Learning/pml-training.csv",sep = ",",na.strings=c("NA","#DIV/0!",""))
testing <- read.csv("~/coursera/Practical Machine Learning/pml-testing.csv",sep = ",",na.strings=c("NA","#DIV/0!",""))
```

## Removing NA's from the training set and testing set

```{r}
a <- sapply(training,is.na)
b <- sapply(as.data.frame(a),sum)
c <- (b == 0)
training <- training[,c]
testing <- testing[,c]
```

## Partitioning the training into two parts

```{r}
inTrain <- createDataPartition(y=training$classe,p = 0.6,list=FALSE)
myTrain <-training[inTrain,]
myTest <- training[-inTrain,]
```

## Removing unnecessary columns from the data

```{r}
myTrain <- myTrain[,-c(1:7)]
myTest <- myTest[,-c(1:7)]
testing <- testing[,-c(1:7,60)] # in actual testing data last column contains index i.e. 1:20
```


## Using machine learning algorithm to fit the model

I am using Random Forest algorithm , because I love its accuracy.

```{r}
mod <- randomForest(classe~.,data = myTrain)
```

## Predictions and ConfusionMatrix

Here I am predicting for test data which is subset of training set. Also I am creating the confusionMatrix in order to check the accuracy of the model

```{r}
predictions <- predict(mod, myTest)
confusionMatrix(predictions,myTest$classe)
```

## Final predictions 

Predicting the final values required for submissions

```{r}
predictions <- predict(mod, testing)
```

## Now creating the output files

```{r}
pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}
pml_write_files(predictions)
```
