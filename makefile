endpoints = out.txt repeaters_out.txt forbidden-suffix.pdf my_log_workflow.png
incidentals = Rplots.pdf
intermediates = ENshort.dat

all: $(endpoints)
	make -C dxcc

rptcsvs = my_lat_long.csv texas-2m-repeaters-2022-01-10.csv texas-70cm-repeaters-2022-01-10.csv
zipped = AM.dat EN.dat HD.dat LA.dat SF.dat CO.dat HS.dat SC.dat counts

.PHONY: all clean deepclean

# Download

l_amat.zip:
	curl -O 'https://data.fcc.gov/download/pub/uls/complete/l_amat.zip'

# Data files

EN.dat: l_amat.zip
	unzip -u $<
	touch EN.dat

ENshort.dat: EN.dat
	head -n 100000 $< > $@

# R analytics

out.txt: allhams.R ENshort.dat
	Rscript $< > $@

repeaters_out.txt: repeaters.R $(rptcsvs)
	Rscript $< > $@  # creates Rplots.pdf too

%.pdf: %.Rmd
	Rscript -e "rmarkdown::render('$<')"

# Graphviz

%.png: %.dot
	dot -Tpng $< > $@




#### clean

clean:
	rm -f $(zipped) $(endpoints) $(incidentals) $(intermediates)
# 'counts' is in contents of zip file
	make -C dxcc clean

deepclean: clean
	rm -f *.zip
