#Function for table1 testing
#if variable is numeric, use t-test, otherwise use fisher's exact test
test <- function(x, ...){
  x <- x[-length(x)]
  y <- unlist(x)
  g <- factor(rep(1:length(x), times=sapply(x, length)))
  
  if(is.numeric(y))
  {
    p_value<- t.test(y ~ g, var.equal = TRUE)$p.value
  }
  else
  {
    p_value <- fisher.test(y, g, alternative = "two.sided", 
                           conf.int = TRUE, conf.level = 0.95)$p.value
  }
  
  if(p_value<0.001)
  {
    return("<0.001")
  }
  else
  {
    p_value <- round(p_value, 3)
    return(p_value)
  }
}

#Function for table 1 summary statistics
#for continous variable, provide summary statistics as mean with SD
my.render.cont <- function(x) {
  with(stats.default(x), 
       c("",
         
         "Mean ± SD" = sprintf("%s (%s)",
                               round_pad(MEAN, 2),
                               round_pad(SD, 2)))
  )
}

#Function to count number of patients in each dose category
#data = name of the dataframe
#name = string to name the count and proportion variable (e.g., "all")
#total = total number of patients in the group
dose_count<-function(data, name, total){
  output<-data.frame(table(data[["week_dose_cat"]], data[["week"]]))
  colnames(output)<-c("week_dose_cat", "week", paste0(name, "_count"))
  
  #calculate proportion of patients in each dose category
  output[[paste0(name, "_prop")]]<-paste0(round(output[[paste0(name, "_count")]]*100/total, 1), "%")
  output[[paste0(name, "_label")]]<-paste0(output[[paste0(name, "_count")]], " (", 
                                           output[[paste0(name, "_prop")]], ")")
  
  return(output)
}

#Function to plot dose distribution
#data = name of the data frame
#var = count variable used to plot the bars (e.g., data$all_count)
#label = variable to be used as label (e.g., data$all_label)
#title = string variable for plot title (e.e., "All patient")
dose_plot<-function(data, var, label, title = "Percent of patients \n in each dose category\n"){
  out<-ggplot(data, aes(fill=week_dose_cat, y=var, x= reorder(week, as.numeric(week))))+ 
    geom_bar(position="fill", stat="identity")+
    scale_fill_manual(values = c("cornflowerblue","gold",  "skyblue4"))+
    labs(
      title = title,
      x = "Week",
      y = "Percent of patient",
    )+theme_classic()+
    scale_y_continuous(expand = c(0, 0), labels = scales::percent)+
    theme(
      plot.title = element_text(hjust = 0.5, size = 9, vjust = -1),
      axis.title.x = element_text(size = 8),
      axis.title.y = element_text(size = 8),
      axis.text.x = element_text(size = 8),
      axis.text.y = element_text(size = 8)
    )+
    labs(fill = "Weekly etelcalcide dose") +  # Change the legend title
    theme(
      legend.text = element_text(size = 8),        # Make legend text smaller
      legend.title = element_text(size = 8),      # Adjust legend title size if needed
      legend.key.size = unit(0.4, 'cm')            # Adjust legend box size
    ) +
    geom_text(aes(label = label),  vjust = ifelse(var<5, -0.5, 0.5),
              position = position_fill(vjust = 0.5), size = 2)
  return(out)
}
