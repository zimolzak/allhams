library(here)
library(dplyr)
library(data.table)
library(ggplot2)
library(lubridate)

message("Reading csv")
Y = fread(here('texas-2m-repeaters-2022-01-10.csv'))
Z = fread(here('texas-70cm-repeaters-2022-01-10.csv'))
head(Y)

Y %>% filter(`Output Freq` < 200 & `Input Freq` < 200) -> vhf  # remove cross-band
qplot(vhf$`Output Freq`)
ggplot(vhf) + aes(`Input Freq`, `Output Freq`) +
	geom_point() +
	geom_abline(intercept = 0, slope = 1) +
	scale_x_continuous(minor_breaks=seq(144, 148, 0.2)) +
	scale_y_continuous(minor_breaks=seq(144, 148, 0.2))

Z %>% filter(`Output Freq` > 400 & `Input Freq` > 400) -> uhf
qplot(uhf$`Output Freq`)
ggplot(uhf) + aes(`Input Freq`, `Output Freq`) +
	geom_point() +
	geom_abline(intercept = 0, slope = 1) +
	scale_x_continuous(breaks=seq(435, 450, 5)) +
	scale_y_continuous(breaks=seq(435, 450, 5))

vhf %>% select(`Uplink Tone`, `Downlink Tone`, Lat, Long, `Last Update`, `Output Freq`) -> vcompare
uhf %>% select(`Uplink Tone`, `Downlink Tone`, Lat, Long, `Last Update`, `Output Freq`) -> ucompare

bind_rows(vcompare, ucompare, .id = "table.id") %>%
mutate(up.tone.num = as.numeric(`Uplink Tone`),
	down.tone.num = as.numeric(`Downlink Tone`),
	band = case_when(table.id == 1 ~ '2m', table.id == 2 ~ '70cm'),
	update.dt = as_date(`Last Update`)
) %>%
filter(Long < 0 & Lat < 40) -> compare

ggplot(compare) +
	aes(x = up.tone.num, y = down.tone.num, color = band) +
	geom_jitter(alpha = 0.5)

ggplot(compare) +
	aes(x = up.tone.num, color = band) +
	geom_density()

ggplot(compare) +
	aes(x = Long, y = Lat, color = band) +
	geom_jitter(alpha = 0.5)

ggplot(compare) +
	aes(x = update.dt, fill = band) +
	geom_histogram()
