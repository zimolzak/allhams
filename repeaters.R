library(here)
library(dplyr)
library(data.table)
library(ggplot2)

message("Reading csv")
Y = fread(here('texas-2m-repeaters-2022-01-10.csv'))
Z = fread(here('texas-70cm-repeaters-2022-01-10.csv'))
head(Y)

Y %>% filter(`Output Freq` < 200 & `Input Freq` < 200) -> vhf  # remove cross-band
qplot(vhf$`Output Freq`)
qplot(vhf$`Input Freq`, vhf$`Output Freq`) +
	geom_abline(intercept = 0, slope = 1) +
	scale_x_continuous(minor_breaks=seq(144, 148, 0.2)) +
	scale_y_continuous(minor_breaks=seq(144, 148, 0.2))

Z %>% filter(`Output Freq` > 400 & `Input Freq` > 400) -> uhf
qplot(uhf$`Output Freq`)
qplot(uhf$`Input Freq`, uhf$`Output Freq`) +
	geom_abline(intercept = 0, slope = 1) +
	scale_x_continuous(breaks=seq(435, 450, 5)) +
	scale_y_continuous(breaks=seq(435, 450, 5))
