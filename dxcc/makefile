.PHONY: all clean

files = mostwanted.csv dxcc.csv who_next.csv
incidentals = dxcc_join.csv who_next_short.csv

all: $(files)

mostwanted.csv: process_mostwanted.py mostwanted.txt
	python $< > $@

dxcc.csv: process_dxcc.py dxcc\ 2022_Current_Deleted.txt notes.txt
	python $<

who_next.csv: who_next.py my_dxcc.csv mostwanted.csv dxcc.csv
	python $<

clean:
	rm -f $(files) $(incidentals)
