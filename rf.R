# Random Forest
library(randomForest)
library(e1071)


credit_data = read.csv("credit_data.csv")

str(credit_data)
 
credit_data$rotulo = as.factor(credit_data$rotulo)

table(credit_data$rotulo)


set.seed(123)
numrow = nrow(credit_data)
trnind = sample(1:numrow,size = as.integer(0.7*numrow))
train_data = credit_data[trnind,]
test_data = credit_data[-trnind,]


#acontece um erro
##Can not handle categorical predictors with more than 53 categories.
rf_fit = randomForest(rotulo~.,data = train_data,mtry=4,maxnodes= 2000,ntree=1000,nodesize = 2)
rf_pred = predict(rf_fit,data = train_data,type = "response")
rf_predt = predict(rf_fit,newdata = test_data,type = "response")

tble = table(train_data$rotulo,rf_pred)
tblet = table(test_data$rotulo,rf_predt)

acc = (tble[1,1]+tble[2,2])/sum(tble)
acct = (tblet[1,1]+tblet[2,2])/sum(tblet)
print(paste("Train acc",round(acc,4),"Test acc",round(acct,4)))

# Grid Search
rf_grid = tune(randomForest,rotulo~.,data = train_data,ranges = list(
  mtry = c(4,5),
  maxnodes = c(700,1000),
  ntree = c(1000,2000,3000),
  nodesize = c(1,2)
),
tunecontrol = tune.control(cross = 5)
)

summary(rf_grid)

best_model = rf_grid$best.model
summary(best_model)

y_pred_train = predict(best_model,data = train_data)
train_conf_mat = table(train_data$rotulo,y_pred_train)

print(paste("Train Confusion Matrix - Grid Search:"))
print(train_conf_mat)

train_acc = (train_conf_mat[1,1]+train_conf_mat[2,2])/sum(train_conf_mat)
print(paste("Train_accuracy-Grid Search:",round(train_acc,4)))

y_pred_test = predict(best_model,newdata = test_data)
test_conf_mat = table(test_data$rotulo,y_pred_test)

print(paste("Test Confusion Matrix - Grid Search:"))
print(test_conf_mat)

test_acc = (test_conf_mat[1,1]+test_conf_mat[2,2])/sum(test_conf_mat)
print(paste("Test_accuracy-Grid Search:",round(test_acc,4)))

# Variable Importance
vari = varImpPlot(best_model)
print(paste("Variable Importance - Table"))
print(vari)
