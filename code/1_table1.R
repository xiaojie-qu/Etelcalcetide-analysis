library(dplyr)
library(readxl)
library(writexl)
library(table1)
library(htmltools)

source("code/function.R")
d<-read_xlsx("data/dataset.xlsx")
summary(d)

#create grouping variable
d$dose_group<-ifelse(d$total_etel_dose<=180, "LD",
              ifelse(d$total_etel_dose>=240, "SD", NA))
summary(as.factor(d$dose_group))

#only keep patients in LD or SD group
d<-d%>%filter(!is.na(d$dose_group))

#re-categorize variables
d$adl<-ifelse(d$adl == "Independent", "Independent", "Dependent/Semi-Dependent")
d$ethnicity<-ifelse(d$ethnicity == "Chinese", "Chinese", "Others")
d$primary_diagnosis<-ifelse(d$primary_diagnosis == "Diabetes Related", "Diabetes Related",
                    ifelse(d$primary_diagnosis == "GN/Presumed GN", 
                           "GN/Presumed GN", "Others"))

d$baseline_pth_group<-ifelse(d$baseline_pth<=100, "1_<=100",
                      ifelse(d$baseline_pth>100 & d$baseline_pth<=125, "2_>100-125",
                             ifelse(d$baseline_pth>125 & d$baseline_pth<=160, "3_>125-160",
                                    ifelse(d$baseline_pth>160, "4_>160", 999))))
summary(as.factor(d$baseline_pth_group))
#get percent and absolute differences in lab parameters
d$ipth_red_abs<-(d$endpoint_pth - d$baseline_pth)*-1
d$ipth_red_percent<-round(d$ipth_red_abs*100/d$baseline_pth, 1)
d$ca_red_abs<-(d$endpoint_ca - d$baseline_ca) * -1
d$ca_red_percent<-round(d$ca_red_abs*100/d$baseline_ca, 1)
d$po4_red_abs<-(d$endpoint_po4 - d$baseline_po4)*-1
d$po4_red_percent<-round(d$po4_red_abs*100/d$baseline_po4, 1)
d$sap_red_abs<-(d$endpoint_sap - d$baseline_sap)*-1
d$sap_red_percent<-round(d$sap_red_abs*100/d$baseline_sap, 1)

#convert relevant variables to factors
d$has_cvd<-as.factor(d$has_cvd)
d$has_dm<-as.factor(d$has_dm)
d$has_htn<-as.factor(d$has_htn)

#export data for subsequent analysis
write_xlsx(d, "data/data_cleaned.xlsx")

#generate table 1 and change in lab parameters
tbl1<-table1(~ total_etel_dose + age + gender + ethnicity + vintage +  
         has_htn + has_dm + has_cvd + primary_diagnosis + 
         vascular_access_type + baseline_pth + baseline_ca +
         baseline_po4 + baseline_sap + baseline_alb + baseline_hb +
         total_alfa_dose + adl + baseline_pth_group + 
         endpoint_pth + endpoint_ca + endpoint_po4 + endpoint_sap +
         ipth_red_abs + ipth_red_percent + ca_red_abs + ca_red_percent +
         sap_red_abs + sap_red_percent + po4_red_abs +
         po4_red_percent|dose_group, data= d, overall = "Total",  render.continuous=c(.="Mean ± SD"), 
       extra.col=list("p-value"=test), extra.col.pos=3)

#save table 1 as html table, which can also be opened in word
save_html(tbl1, file = "output/table1.html")
