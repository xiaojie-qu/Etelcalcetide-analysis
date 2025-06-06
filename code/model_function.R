#Function for linear model
#x = outcome variable (e.g., "group")
#y = string of outcome variables (e.g., "variable_1 + var2 + var3....")
#data = dataframe (e.g., data)

model_linear<-function(x, y, data){
  
  #create model formula
  string.formula<-paste0(x, "~", y)
  lm.formula<-as.formula(string.formula)
  
  model_output<-lm(lm.formula, data = data)
  
  # create a table containing only the variable of interest (i.e., dose_group)
  output_summary<-summary(model_output)
  output_summary<-data.frame(output_summary[["coefficients"]])
  output_summary$variable<-row.names(output_summary)
  output_summary<-output_summary%>%filter(variable == "dose_group")
  
  #obtain regression coefficient of dose_group
  beta<-model_output[["coefficients"]][["dose_group"]]
  
  #obtain p-value
  p_value<-round(output_summary[,4 ], 3)
  p_value<-ifelse(p_value<0.001, paste0("<0.001**"),
                  ifelse(p_value<0.05, paste0(p_value, "*"), p_value))
  
  #obtain 95% confidence interval
  ci<-data.frame(confint(model_output))
  ci$variable<-row.names(ci)
  colnames(ci)<-c("lower", "upper", "variable")
  #only keep 95%ci of dose_group
  output<-ci%>%filter(variable == "dose_group")
  
  #formatting output
  output$beta<-round(beta, 2)
  output$p_value<-p_value
  output$result<-paste0(output$beta, " (", round(output$lower, 2), ", ", round(output$upper, 2), ")")
  
  #x = outcome variable
  output$outcome<-x
  
  return(output)
}


#Function for weighted model
model_weight<-function(x, y, data){
  
  string.formula<-paste0(x, "~", y)
  lm.formula<-as.formula(string.formula)
  
  model_output<-lm(lm.formula, data = d2, weights = weight)
  # create a table containing only the variable of interest (i.e., dose_group)
  output_summary<-summary(model_output)
  output_summary<-data.frame(output_summary[["coefficients"]])
  output_summary$variable<-row.names(output_summary)
  output_summary<-output_summary%>%filter(variable == "dose_group")
  
  #obtain regression coefficient of dose_group
  beta<-model_output[["coefficients"]][["dose_group"]]
  
  #obtain p-value
  p_value<-round(output_summary[,4 ], 3)
  p_value<-ifelse(p_value<0.001, paste0("<0.001**"),
                  ifelse(p_value<0.05, paste0(p_value, "*"), p_value))
  
  #obtain 95% confidence interval
  ci<-data.frame(confint(model_output))
  ci$variable<-row.names(ci)
  colnames(ci)<-c("lower", "upper", "variable")
  #only keep 95%ci of dose_group
  output<-ci%>%filter(variable == "dose_group")
  
  #formatting output
  output$beta<-round(beta, 2)
  output$p_value<-p_value
  output$result<-paste0(output$beta, " (", round(output$lower, 2), ", ", round(output$upper, 2), ")")
  
  #x = outcome variable
  output$outcome<-x
  
  return(output)
}
