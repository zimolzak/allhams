library(here)
library(dplyr)

X = read.csv(here('ENshort.dat'), header = FALSE, sep="|")
dim(X)

X %>%
rename(tablename = V1, num = V2, callsign = V5, code = V6, lnum = V7, fullname = V8,
	firstname = V9, middlename = V10, lastname = V11, suffix = V12, address = V16,
	city = V17, state = V18, zip = V19,
	miscnum = V20, misctext = V21, zeronum = V22, othernum = V23, othercode = V24) -> renamed
	
renamed %>%
select(tablename, V3, V4, code, middlename, V13, V14, V15, state, miscnum, zeronum, othercode, V25, V26, V27, V28, V29, V30) -> interesting_cols
	
head(renamed)

table(renamed$tablename)
table(renamed$code)

cat("\n\nmiddle\n")
table(renamed$middlename)
cat("\n\nsuffix\n")
table(renamed$suffix)
cat("\n\nstate\n")
table(renamed$state)

cat("\n\ninteresting\n")
head(interesting_cols)

cat("\n\n\n\n----\n\n\n\n")

for(i in 1:ncol(interesting_cols)){
	print(i)
	print(table(interesting_cols[,i], useNA = "always"))
	cat("\n\n")
}
