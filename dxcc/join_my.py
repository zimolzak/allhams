import pandas as pd

# Inputs

mine = pd.read_table('my_dxcc.csv', sep=',')
dxcc_details = pd.read_table('dxcc.csv', sep=',').rename(columns = {'dxcc_code':'dxcc'})

# read from copy paste file

updated_copy = []
with open('my_from_lotw.txt') as fh:
    for line in fh:
        country_words = line.split()[:-1]
        country_name = ' '.join(country_words) + ' **'
        updated_copy.append(country_name.upper())

# Processing

details_of_worked = pd.merge(mine, dxcc_details, how='left', on=['dxcc'])
details_of_worked['e with n'] = details_of_worked.entity + details_of_worked.dxcc.apply(lambda n: ' ' + str(n))

in_csv = list(details_of_worked['e with n'])
in_csv = [s.upper() for s in in_csv]

both_lists = in_csv + updated_copy
both_lists.sort()

# print

for s in both_lists:
    if '**' in s:
        print(s, end=' ')
    else:
        print(s)
