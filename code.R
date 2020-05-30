library(tidycovid19)
library(openxlsx)
library(ggcorrplot)
library(readxl)
library(ggplot2)
library(cowplot)

### get the data

all<-download_merged_data(silent = TRUE, cached = TRUE) # World.
A_all <- subset(all, all$iso3c =="ARG") # Argentina.

### Export data. 

write.xlsx(ARG_all, file="ARG_all2.xlsx") 

### Import the data frame and use the first page of the spreadsheet ARG_all
# Make sure you are in the correct working directory

ARG_all <- read_excel("ARG_all.xlsx", sheet = "global")

### Correlation. Pearson.

corr <- cor(ARG_all[,c(7,8,15,16,23,24,25,26,27,28,29,30,31)], use = "pairwise.complete.obs")

correlation <- ggcorrplot(corr,outline.color = "gray",  
                          show.legend = TRUE, 
                          legend.title = "Corr",
                          #pch = 2,
                          colors = c("#00CED1", "white", "#FF4500"),
                          lab = T,
                          lab_size = 3) 

correlation

### Additionally we can see it interactively for a better exploration
library(plotly)

ggplotly(correlation)

### Import the data frame and use the first page of the spreadsheet ARG_all
# Make sure you are in the correct working directory

cases <- read_excel("ARG_all.xlsx", sheet = "cases")
mobility <- read_excel("ARG_all.xlsx", sheet = "mobility")

### Plots.

confirmed_plot<- ggplot(cases, aes(x=date, y=result, group = indicator, color = indicator))+
  geom_line(size=1)+
  ylab("%")+
  theme_light()+
  ggtitle("Confirmed")+
  theme(legend.title = element_blank(), legend.position="bottom", 
        axis.title.x = element_blank())+
  scale_color_brewer(palette="Set1")
  
  
mobility_plot <- ggplot(mobility, aes(x=date, y=result, group = indicator, color = indicator))+
  geom_line(size=1)+
  theme_light()+
  ggtitle("Mobility")+
  theme(legend.title = element_blank(), legend.position="bottom", 
        axis.title.x = element_blank(),axis.title.y = element_blank())+
  geom_hline(aes(yintercept=0), color="black",size=1,
             linetype="dashed")+
  geom_hline(aes(yintercept=100), color="black",size=1,
             linetype="dashed")+
  scale_color_brewer(palette="Set1")

### Additionally we can see it interactively for a better exploration
library(plotly)

ggplotly(confirmed_plot)
ggplotly(mobility_plot)

### Join them in a single plot

  plot_grid(confirmed_plot,mobility_plot,nrow = 2)


