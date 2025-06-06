library(dplyr)
library(readxl)
library(writexl)
library(table1)
source("code/function.R")

dose<-read_xlsx("data/dose_data.xlsx")
d3<-read_xlsx("data/data_cleaned.xlsx")

#joining patient's baseline pth group, dose group to weekly dose data
d3<-d3%>%select(id, dose_group, baseline_pth_group)
dose<-dose%>%left_join(d3, by = c("id"))
remove(d3)

#categorize weekly dose
dose$week_dose_cat<-ifelse(dose$week_dose<=7.5, "1_<=7.5",
                           ifelse(dose$week_dose>7.5 & dose$week_dose<10, "2_>7.5-<10",
                                  ifelse(dose$week_dose>=10, "3_>=10", 999)))

#count the number of patients in each dose category by dose group
ld<-dose%>%filter(dose_group == "LD")
sd<-dose%>%filter(dose_group == "SD")

all<-dose_count(dose, "all", 239)
ld<-dose_count(ld, "ld", 124)
sd<-dose_count(sd, "sd", 115)

all<-all%>%left_join(ld, by = c("week_dose_cat", "week"))%>%
  left_join(sd, by = c("week_dose_cat", "week"))

#save output for plotting
write_xlsx(all, "output/week_dose_by_group.xlsx")

#count the number of patients in each of the baseline PTH category
pth1<-dose%>%filter(baseline_pth_group == "1_<=100")
pth2<-dose%>%filter(baseline_pth_group == "2_>100-125")
pth3<-dose%>%filter(baseline_pth_group == "3_>125-160")
pth4<-dose%>%filter(baseline_pth_group == "4_>160")

pth1<-dose_count(pth1, "grp1", 62)
pth2<-dose_count(pth2, "grp2", 61)
pth3<-dose_count(pth3, "grp3", 55)
pth4<-dose_count(pth4, "grp4", 61)
pth1<-pth1%>%left_join(pth2, by = c("week_dose_cat", "week"))%>%
  left_join(pth3, by = c("week_dose_cat", "week"))%>%
  left_join(pth4, by = c("week_dose_cat", "week"))

write_xlsx(pth1, "output/week_dose_by_pth.xlsx")
