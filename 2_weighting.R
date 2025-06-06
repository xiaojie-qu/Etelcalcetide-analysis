#Load necessary libraries
library(dplyr)
library(readxl)
library(writexl)
library(WeightIt)
library(tidysmd)

#load data
d1<-read_xlsx("data/data_cleaned.xlsx")

#Convert dose group to 0/1 for glm
d1$dose_group<-ifelse(d1$dose_group == "SD", 1, 0)

#estimate propensity score
ps<- glm(dose_group ~ age + gender + ethnicity + log(vintage+1) +  
           has_htn + has_dm + has_cvd + primary_diagnosis + 
           vascular_access_type + baseline_pth + baseline_ca +
           baseline_po4 + baseline_sap + baseline_alb + baseline_hb +
           total_alfa_dose + adl , family = binomial, data = d1)
d1$ps <- predict(ps, type = "response")

#calculate weight for ipsw
d1<-d1%>%mutate(weight = ifelse(dose_group == 1, 1/ps, 1/(1 - ps)))
#keep weighted cohort for model
write_xlsx(d1, "data/data_for_model.xlsx")

#calculate standard mean differences before and after weighting
smd <- tidy_smd(
  d1, 
  c(age, gender, ethnicity, vintage, 
      has_htn, has_dm, has_cvd, primary_diagnosis,
      vascular_access_type, baseline_pth, baseline_ca,
      baseline_po4, baseline_sap, baseline_alb, baseline_hb,
      total_alfa_dose, adl),
  .group = dose_group,
  .wts = weight
)
smd$smd_abs<-abs(smd$smd)

#keep calculated smd for plotting
write_xlsx(smd, "output/smd.xlsx")
