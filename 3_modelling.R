library(dplyr)
library(readxl)
library(writexl)
library(data.table)
source("code/model_function.R")

#Load data
d2<-read_xlsx("data/data_for_model.xlsx")

#Creating list to allow function loop over all outcomes
outcomes<-c("ipth_red_abs", "ipth_red_percent", "ca_red_abs", "ca_red_percent",
        "po4_red_abs", "po4_red_percent", "sap_red_abs", "sap_red_percent")

#Model 1: unadjusted
m1_output<-list()
for (i in seq_along(outcomes)){
  temp<-model_linear(outcomes[[i]], "dose_group", data = d2)
  temp$model<-"model1"
  m1_output[[i]]<-temp
}
m1_output<-rbindlist(m1_output)

#create formular string for adjusted models (2, 4)
variables<-"dose_group + age + gender + ethnicity + log(vintage+1) +  
  has_htn + has_dm + has_cvd + primary_diagnosis + 
  vascular_access_type + baseline_pth + baseline_ca +
  baseline_po4 + baseline_sap + baseline_alb + baseline_hb +
  total_alfa_dose + adl"

#Model 2: adjusted
m2_output<-list()
for (i in seq_along(outcomes)){
  temp2<-model_linear(outcomes[[i]], variables, data =d2)
  temp2$model<-"model2"
  m2_output[[i]]<-temp2
}
m2_output<-rbindlist(m2_output)

#Model 3: unadjusted weighted
m3_output<-list()
for (i in seq_along(outcomes)){
  temp3<-model_weight(outcomes[[i]], "dose_group", data = d2)
  temp3$model<-"model3"
  m3_output[[i]]<-temp3
}
m3_output<-rbindlist(m3_output)

#Model 4: adjusted and weighted
m4_output<-list()
for (i in seq_along(outcomes)){
  temp4<-model_weight(outcomes[[i]], variables, data = d2)
  temp4$model<-"model4"
  m4_output[[i]]<-temp4
}
m4_output<-rbindlist(m4_output)

#Format output
model_out<-rbind(m1_output, m2_output, m3_output, m4_output)
model_out<-model_out%>%select(model, outcome, result, p_value)
write_xlsx(model_out, "output/model_ouput.xlsx")
