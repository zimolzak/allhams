import re
import pandas as pd
from tqdm import tqdm

pd.set_option('display.max_rows', 500)

IMPORTANT_COLUMNS = [4, 24, 59, 65, 71, 77, 80]
PAREN_RE = re.compile('\(.*\)')
COLUMN_NAMES = [
    'prefix', 'entity', 'continent', 'itu_zone', 'cq_zone', 'dxcc_code',  # columns directly from txt
    'arrl_outgoing', 'third_party', 'note', 'deleted'  # generated columns
]

DF = pd.DataFrame([[None] * len(COLUMN_NAMES)], columns = COLUMN_NAMES)

def split_multiple(string, columns):
    result = []
    for i in range(len(columns) - 1):
        result.append(string[columns[i]:columns[i+1]])
    return [s.rstrip() for s in result]

if __name__ == '__main__':
    with open('dxcc 2022_Current_Deleted.txt') as fh:
        printing = False
        deleted = False
        for line in tqdm(fh, total=564):

            # Data do not start until after a lot of underscores.
            if '____' in line:
                printing = True
                continue

            # Turn on deleted entry flag when certain line matched
            if 'DELETED' in line:
                deleted = True

            # Lines without lots of spaces are likely footnotes.
            if '     ' not in line:
                continue

            if printing:
                prefix, entity, continent, itu_zone, cq_zone, dxcc_code = split_multiple(line, IMPORTANT_COLUMNS)

                # Parse things within the prefix field, and generate more fields from it.
                if '*' in prefix:
                    arrl_outgoing = True
                    prefix = prefix.replace('*', '')
                else:
                    arrl_outgoing = False

                if '#' in prefix:
                    third_party = True
                    prefix = prefix.replace('#', '')
                else:
                    third_party = False

                if PAREN_RE.search(prefix):
                    note = PAREN_RE.search(prefix).group(0)
                    note = note.replace(')', '').replace('(', '')
                    prefix = PAREN_RE.sub('', prefix)
                else:
                    note = ''

                # Skip blank line.
                if entity == '':
                    continue
                # Skip header of deleted entities
                if 'Prefix' in prefix:
                    continue

                # Make pandas data frame
                df_row = pd.DataFrame(
                    [[prefix, entity, continent, itu_zone, cq_zone, dxcc_code, arrl_outgoing, third_party, note, deleted]],
                    columns=COLUMN_NAMES
                )
                DF = pd.merge(DF, df_row, how='outer')

DF = DF.iloc[1:]  # Drop the [None, None, ....] row.

#### Outputs

print()
print(DF['continent'].value_counts())
print()
print(DF['arrl_outgoing'].value_counts())
print()
print(DF['third_party'].value_counts())
print()
print(DF['deleted'].value_counts())
print()

DF.to_csv('dxcc.csv')
