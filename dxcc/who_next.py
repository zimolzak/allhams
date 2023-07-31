import pandas as pd

# Inputs

mine = pd.read_table('my_dxcc.csv', sep=',')
wanted = pd.read_table('mostwanted.csv', sep=',')
dxcc_details = pd.read_table('dxcc.csv', sep=',').rename(columns = {'dxcc_code':'dxcc'})
mine['worked'] = True

n_worked = mine.shape[0]
n_needed = 100 - n_worked



# Processing

final_df = pd.merge(mine, wanted, how='outer', on=['dxcc'])
final_df = final_df[['dxcc', 'worked', 'rank', 'prefix', 'name']]  # drop 'empty'
final_df = final_df.sort_values('rank', ascending=False)

short = final_df[final_df.worked != True].head(n_needed)
short_continents = pd.merge(short, dxcc_details[['dxcc', 'continent']], how='left', on=['dxcc'])


# Outputs

final_df.to_csv('who_next.csv')
short_continents[['dxcc', 'prefix', 'name', 'continent']].to_csv('who_next_short.csv')



# Stats

print()
print(short_continents['continent'].value_counts())
print()
print(short_continents['continent'].value_counts() / n_needed)
print()
