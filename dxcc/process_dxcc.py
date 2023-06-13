import re

IMPORTANT_COLUMNS = [4, 24, 59, 65, 71, 77, 80]
PAREN_RE = re.compile('\(.*\)')

def split_multiple(string, columns):
    result = []
    for i in range(len(columns) - 1):
        result.append(string[columns[i]:columns[i+1]])
    return [s.rstrip() for s in result]

if __name__ == '__main__':
    with open('dxcc 2022_Current_Deleted.txt') as fh:
        printing = False
        for line in fh:

            # Data do not start until after a lot of underscores.
            if '____' in line:
                printing = True
                continue

            # Long lines are very likely footnotes.
            if len(line) > 81:
                continue

            # Short lines without lots of spaces are likely footnotes.
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

                print((prefix, entity, continent, itu_zone, cq_zone, dxcc_code, arrl_outgoing, third_party, note))
