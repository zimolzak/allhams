import pandas as pd

"""Takes in a text file copy pasted from lotw and hopefully makes it
easy to say who's new. Not run by makefile. Just do it at command
line: `python join_my.py`

"""

# Inputs

TABLE_OF_WORKED_DXCC_NUMBERS = pd.read_table('my_dxcc.csv', sep=',')
dxcc_details = pd.read_table('dxcc.csv', sep=',').rename(columns = {'dxcc_code':'dxcc'})

# read from copy paste file

NEW_LOTW_COUNTRY_LIST = []
with open('my_from_lotw.txt') as fh:
    for line in fh:
        country_words = line.split()[:-1]
        country_name = ' '.join(country_words) + ' **'
        NEW_LOTW_COUNTRY_LIST.append(country_name.upper())

# Processing

details_of_worked = pd.merge(TABLE_OF_WORKED_DXCC_NUMBERS, dxcc_details, how='left', on=['dxcc'])
details_of_worked['e with n'] = details_of_worked.entity + details_of_worked.dxcc.apply(lambda n: ' ' + str(n))

OLD_CSV_COUNTRY_LIST = list(details_of_worked['e with n'])
OLD_CSV_COUNTRY_LIST = [s.upper() for s in OLD_CSV_COUNTRY_LIST]

both_lists = OLD_CSV_COUNTRY_LIST + NEW_LOTW_COUNTRY_LIST
both_lists.sort()

# print

for s in both_lists:
    if '**' in s:
        print(s, end=' ')
    else:
        print(s)

print("""

** means it came from lotw.
Number means it's from my_dxcc.csv on disk.
Basically look for any lines with two **.
But it gets messed up because alphabetical order and abbreviations.
""")
