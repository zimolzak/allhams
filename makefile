all: out.txt

.PHONY: all clean deepclean

l_amat.zip:
	curl -O 'https://data.fcc.gov/download/pub/uls/complete/l_amat.zip'

EN.dat: l_amat.zip
	unzip -u $<
	touch EN.dat

ENshort.dat: EN.dat
	head -n 10000 $< > $@

out.txt: allhams.R ENshort.dat
	Rscript $< > $@

clean:
	rm -f *.dat counts out.txt ENshort.dat

deepclean: clean
	rm -f *.zip
