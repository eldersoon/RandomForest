library(mctest)
library(dummies)
library(Information)
library(pROC)

credit_data = read.csv("credit_data.csv")
credit_data$rotulo = credit_data$rotulo 

# I.V Calculation
IV <- create_infotables(data=credit_data, y="rotulo", parallel=FALSE)
for (i in 1:length(colnames(credit_data))){
  seca = IV[[1]][i][1]
  sum(seca[[1]][5])
  print(paste(colnames(credit_data)[i],",IV_Value:",round(sum(seca[[1]][5]),4)))
}

# Dummy variables creation
dummy_salario =data.frame(dummy(credit_data$salario))
dummy_idade = data.frame(dummy(credit_data$idade))
dummy_emprestimo =  data.frame(dummy(credit_data$emprestimo))


# Cleaning the variables name from . to _
colClean <- function(x){ colnames(x) <- gsub("\\.", "_", colnames(x)); x } 
dummy_salario =colClean(dummy_salario);
dummy_idade = colClean(dummy_idade);
dummy_emprestimo =  colClean(dummy_emprestimo);


# Setting seed for repeatability of results of train & test split
set.seed(123)
numrow = nrow(credit_data)
trnind = sample(1:numrow,size = as.integer(0.7*numrow))
train_data = credit_data[trnind,]
test_data = credit_data[-trnind,]


# Removing insignificant variables one by one
remove_cols_insig = c("cliente_id")

remove_cols = c(remove_cols_insig)

glm_fit = glm(rotulo ~.,family = "binomial",data = train_data[,!(names(train_data) %in% remove_cols)])
# Significance check - p_value
summary(glm_fit)

# Multi collinearity check - VIF
remove_cols_vif = c(remove_cols,"rotulo")
vif_table = imcdiag(train_data[,!(names(train_data) %in% remove_cols_vif)],train_data$rotulo,detr=0.001, conf=0.99)
vif_table  

# Predicting probabilities
train_data$glm_probs = predict(glm_fit,newdata = train_data,type = "response")
test_data$glm_probs = predict(glm_fit,newdata = test_data,type = "response")

# Area under ROC

ROC1 <- roc(as.factor(train_data$rotulo),train_data$glm_probs)
plot(ROC1, col = "blue")
print(paste("Area under the curve",round(auc(ROC1),4))) 

# Actual prediction based on threshold tuning 
threshold_vals = c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9)
for (thld in threshold_vals){
  train_data$glm_pred = 0
  train_data$glm_pred[train_data$glm_probs>thld]=1
  
  tble = table(train_data$glm_pred,train_data$rotulo)
  acc = (tble[1,1]+tble[2,2])/sum(tble)
  print(paste("Threshold",thld,"Train accuracy",round(acc,4)))
  
}

# Best threshold from above search is 0.5 with accuracy as 0.7841
best_threshold = 0.5

# Train confusion matrix & accuracy
train_data$glm_pred = 0
train_data$glm_pred[train_data$glm_probs>best_threshold]=1
tble = table(train_data$glm_pred,train_data$rotulo)
acc = (tble[1,1]+tble[2,2])/sum(tble)
print(paste("Confusion Matrix - Train Data"))
print(tble)
print(paste("Train accuracy",round(acc,4)))

# Test confusion matrix & accuracy
test_data$glm_pred = 0
test_data$glm_pred[test_data$glm_probs>best_threshold]=1
tble_test = table(test_data$glm_pred,test_data$class)
acc_test = (tble_test[1,1]+tble_test[2,2])/sum(tble_test)
print(paste("Confusion Matrix - Test Data"))
print(tble_test)
print(paste("Test accuracy",round(acc_test,4)))

