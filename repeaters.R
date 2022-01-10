library(here)
library(dplyr)
library(data.table)
library(ggplot2)
library(lubridate)

message("Reading csv")
Y = fread(here('texas-2m-repeaters-2022-01-10.csv'))
Z = fread(here('texas-70cm-repeaters-2022-01-10.csv'))
L = fread(here('my_lat_long.csv'))  # just 1 line like 31.234,-90.123
MYLAT = L$V1
MYLON = L$V2

Y %>%
filter(`Output Freq` < 200 & `Input Freq` < 200) %>%
select(-EchoLink) -> vhf  # remove cross-band

Z %>%
filter(`Output Freq` > 400 & `Input Freq` > 400) %>%
select(-EchoLink) -> uhf

bind_rows(vhf, uhf, .id = "table.id") %>%
mutate(up.tone.num = as.numeric(`Uplink Tone`),
	down.tone.num = as.numeric(`Downlink Tone`),
	band = case_when(table.id == 1 ~ '2m', table.id == 2 ~ '70cm'),
	update.dt = as_date(`Last Update`),
	dist.nm = sqrt((`Lat` - MYLAT)^2 + (`Long` - MYLON)^2) * 60
) %>%
filter(Long < 0 & Lat < 40) -> compare




###### text report

compare %>%
filter(dist.nm < 15, Use == "OPEN") -> nearby

dim(nearby)

nearby %>% arrange(dist.nm) %>% select(Call, `Output Freq`, dist.nm, Location)




###### plots

qplot(vhf$`Output Freq`)

ggplot(vhf) + aes(`Output Freq`, `Input Freq`) +
	geom_jitter(alpha = 0.1) +
	geom_abline(intercept = 0, slope = 1) +
	scale_x_continuous(minor_breaks=seq(144, 148, 0.2)) +
	scale_y_continuous(minor_breaks=seq(144, 148, 0.2))

qplot(uhf$`Output Freq`)

ggplot(uhf) + aes(`Output Freq`, `Input Freq`) +
	geom_jitter(alpha = 0.1) +
	geom_abline(intercept = 0, slope = 1) +
	scale_x_continuous(breaks=seq(435, 450, 5)) +
	scale_y_continuous(breaks=seq(435, 450, 5)) +
	geom_density_2d()

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

ggplot(nearby) +
	aes(x = Long, y = Lat, color = band) +
	geom_jitter(alpha = 0.5) +
	geom_vline(xintercept = MYLON) +
	geom_hline(yintercept = MYLAT)

ggplot(compare %>% filter(dist.nm < 100, Use == "OPEN")) +
	aes(x = dist.nm, color = band) +
	geom_density()
