library(here)
library(dplyr)
library(data.table)
library(ggplot2)

message("Reading csv")
Y = fread(here('texas-2m-repeaters-2022-01-10.csv'))
head(Y)

Y %>% filter(`Output Freq` < 200 & `Input Freq` < 200) -> vhf  # remove cross-band
qplot(vhf$`Output Freq`)
qplot(vhf$`Input Freq`, vhf$`Output Freq`) +
	geom_abline(intercept = 0, slope = 1) +
	scale_x_continuous(minor_breaks=seq(144, 148, 0.2)) +
	scale_y_continuous(minor_breaks=seq(144, 148, 0.2))
