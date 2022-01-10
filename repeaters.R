library(here)
library(dplyr)
library(data.table)
library(ggplot2)

message("Reading csv")
Y = fread(here('texas-2m-repeaters-2022-01-10.csv'))
head(Y)

qplot(Y$"Output Freq")
