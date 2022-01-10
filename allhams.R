library(here)
library(dplyr)
library(data.table)

message("Reading dat (~8 sec...)")
X = fread(here('EN.dat'), header = FALSE, sep="|", quote="")
# ENshort.dat
dim(X)

message("Processing dat")
X %>%
rename(tablename = V1, num = V2, callsign = V5, code = V6, lnum = V7, fullname = V8,
	firstname = V9, middlename = V10, lastname = V11, suffix = V12, address = V16,
	city = V17, state = V18, zip = V19,
	weird_addr_text = V20, misctext = V21, zeronum = V22, othernum = V23, othercode = V24) -> renamed

message("Output tables (~6 sec...)")
head(renamed)
cat("\n\n\n\n----\n\n\n\n")
for(i in c(1,3,4,6,10,13,14,15,18,22,24:30)){
	cat("Column ", i, " (", names(renamed)[i], ")", ":", sep ="")
	print(table(renamed[, ..i], useNA = "always"))
	cat("\n")
}
