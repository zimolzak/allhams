.PHONY: all clean

files = mostwanted.csv dxcc.csv

all: $(files)

mostwanted.csv: process_mostwanted.py mostwanted.txt
	python $< > $@

dxcc.csv: process_dxcc.py dxcc\ 2022_Current_Deleted.txt notes.txt
	python $<

clean:
	rm -f $(files) dxcc_join.csv
