IMPORTANT_COLUMNS = [4, 24, 55, 65, 71, 77]

def split_multiple(string, columns):
    result = []
    for i in range(len(columns) - 1):
        result.append(string[columns[i]:columns[i+1]])
    return result

if __name__ == '__main__':
    with open('dxcc 2022_Current_Deleted.txt') as fh:
        printing = False
        for line in fh:
            if '____' in line:
                printing = True
                continue
            if printing:
                sliced = split_multiple(line, IMPORTANT_COLUMNS)
                print(sliced)
