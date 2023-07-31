JUNK = "<td style='text-align:center;'><a style='underline:none;' href='https://clublog.freshdesk.com/support/solutions/articles/77534-whitelists'>&#x2705;,"

J2 = "<p><table><tr><th>Rank</th><th>Prefix</th><th>Entity Name</th><th>Whitelisted?</th>"

J3 = "</tr></table></p></div>"

print("rank,prefix,dxcc,name,empty")

with open('mostwanted.txt') as fh:
    for line in fh:
        line = line.replace(',', '_')
        line = line.replace('</tr><tr>', '\n')
        line = line.replace('<td>', '')
        line = line.replace('</td>', ',')
        line = line.replace('</a>', '')
        line = line.replace("<a href='mostwanted2.php?dxcc=", ',')

        line = line.replace(JUNK, '')
        line = line.replace(J2, '')
        line = line.replace(J3, '')

        line = line.replace('.', '')
        line = line.replace("'>", ',')
        line = line.replace(",,", ',')
        
        print(line)
