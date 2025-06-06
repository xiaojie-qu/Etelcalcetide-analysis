library(readxl)
library(grid)
library(ggplot2)
library(gridExtra)
library(tidysmd) #needed for love plot
source("code/function.R")

#===========Love plot====================================
smd<-read_xlsx("output/smd.xlsx")

smd$method<-ifelse(smd$method == "weight", "After weighing", "Before weighing")
smd$variable <- with(smd, reorder(variable, abs(smd)))

ggplot(smd,aes(x = abs(smd),y = variable, group = method, color = method))+
  geom_love() +
  scale_color_manual(values = c("After weighing" = "cornflowerblue", "Before weighing" = "gold")) +  # Custom colors
  labs(
    title = "Absolute standardized mean difference (SMD) before and after weighing",  # Set title
    x = "Absolute SMD",               # Set x-axis label
    y = "Variable",                   # Set y-axis label
    color = "Legend"                  # Set legend title
  ) +
  theme_classic()+
  theme(
    plot.title = element_text(hjust = 0.5, size = 12),
  )
ggsave(path = "output", width = 8, height = 5, dpi=600, filename = "smd.png")


#===============dose distribution by dose group====================
dose<-read_xlsx("output/week_dose_by_group.xlsx")
levels(dose$week_dose_cat)<-c("≤7.5mg/week",">7.5mg-<10mg/week","≥10mg/week")

all<-dose_plot(dose, dose$all_count, label = dose$all_prop, title = "All patients") +
  theme(legend.position = "none")
ld<-dose_plot(dose, dose$ld_count, label = dose$ld_prop, title = "Patients on low dose")+
  theme(legend.position = "none")
sd<-dose_plot(dose, dose$sd_count, label = dose$sd_prop, title = "Patients on standard dose")+
  theme(legend.position = "none")

dose_group<- grid.arrange(all, ld, sd, ncol = 3,
                         top = textGrob("Percent of patients in each etelcalcetide dose category at 4-week intervals", 
                                        gp = gpar(fontsize = 10)))
ggsave("output/dose_dist_group.png", dose_group, width = 8, height = 4)

#------------------plot by baseline pth--------------------
dose_pth<-read_xlsx("output/week_dose_by_pth.xlsx")
levels(dose_pth$week_dose_cat)<-c("≤7.5mg/week",">7.5mg-<10mg/week","≥10mg/week")

pth1<-dose_plot(dose_pth, dose_pth$grp1_count, label = dose_pth$grp1_prop, title = "PTH≤100 pmol/L (N=62)")+
  theme(legend.position = "none")

pth2<-dose_plot(dose_pth, dose_pth$grp2_count, label = dose_pth$grp2_prop, title = "PTH>100 and ≤125 pmol/L (N=61)")+
  theme(legend.position = "none")

pth3<-dose_plot(dose_pth, dose_pth$grp3_count, label = dose_pth$grp3_prop, title = "PTH>125 and ≤160 pmol/L (N=55)")+
  theme(legend.position = "none")

pth4<-dose_plot(dose_pth, dose_pth$grp4_count, label = dose_pth$grp4_prop, title = "PTH>160 pmol/L (N=61)")+
  theme(legend.position = "none")

dose_pth<-grid.arrange(pth1, pth2, pth3, pth4, ncol = 2, 
                       top = "Percent of patients in each etelcalcetide dose category at 4-week intervals")
ggsave("output/dose_dist_pth.png", dose_pth, width = 8, height = 10)
