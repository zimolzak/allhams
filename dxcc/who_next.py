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

continents_need = pd.merge(
    final_df[final_df.worked != True],
    dxcc_details[['dxcc', 'continent']],
    how='left',
    on=['dxcc']
)

short_continents = continents_need.head(n_needed)



# Outputs

final_df.to_csv('who_next.csv')
continents_need[['dxcc', 'prefix', 'name', 'continent']].to_csv('continents_need.csv')
continents_need[['dxcc', 'prefix', 'name', 'continent']][continents_need.continent == 'EU'].to_csv('continents_need_EU.csv')
short_continents[['dxcc', 'prefix', 'name', 'continent']].to_csv('who_next_short.csv')



# Stats

print()
print(short_continents['continent'].value_counts())
print()
print(short_continents['continent'].value_counts() / n_needed)
print()
