"""
    La vecina de mi abuela es la pone todo eso manualmente; yo no.
"""
table = "table.csv"
states = "states.txt"

data = []

fi = open(table, 'r')
lines = fi.readlines()
fi.close()

for l in lines:
    data.append(l.split(","))

# for d in data:
#     print(d)

case = '''\t6'b{}:\t\t\t\t\t// STATE {}\n\
        \tbegin\n\
        \t\tFR = {};\n\
        \t\tRF = {};\n\
        \t\tIR = {};\n\
        \t\tMAR = {};\n\
        \t\tMDR = {};\n\
        \t\tReadWrite = {};\n\
        \t\tMOV = {};\n\
        \t\tMA = 2'b{};\n\
        \t\tMB = 2'b{};\n\
        \t\tMC = 2'b{};\n\
        \t\tMD = {};\n\
        \t\tME = {};\n\
        \t\tOP = 5'b{};\n\
        \t\tInv = {};\n\
        \t\tCR = 6'b{};\t// STATE {}\n\
        \t\tN = 3'b{};\t\t// {}\n\
        \t\tS = 3'b{};\n\
        \t\tMINCR = {};\n\
        \tend\n\
'''

fo = open(states, 'w')
fo.write("\tcase(state)\n")
for d in data:
    d[0] = bin(int(d[1])).replace("0b", "")
    d[0] = (6-len(d[0]))*'0' + d[0]
    d[22] = bin(int(d[22])).replace("0b", "")
    d[22] = (6-len(d[22]))*'0' + d[22]
    fo.write(case.format(d[0], d[1], # CASE
                        d[2],   #FR
                        d[3],   #RF
                        d[4],   #IR
                        d[5],   #MAR
                        d[6],   #MDR
                        d[7],   #R/W
                        d[8],   #MOV
                        d[9],   #MA
                        d[10],  #MB
                        d[11],  #MC
                        d[12],  #MD
                        d[13],  #ME
                        d[14],  #OP
                        d[20],  #INV
                        d[22],  d[22], #CR
                        d[19], d[23].replace("\n", ""), #N, SELECTION
                        d[21],  #S
                        d[15])) #MINCR

fo.write('''\t6'b000000:\t\t// STATE 0\n\
        \tbegin\n\
        \t\tFR = 0;\n\
        \t\tRF = 0;\n\
        \t\tIR = 0;\n\
        \t\tMAR = 0;\n\
        \t\tMDR = 0;\n\
        \t\tReadWrite = 0;\n\
        \t\tMOV = 0;\n\
        \t\tMA = 2'b00;\n\
        \t\tMB = 2'b00;\n\
        \t\tMC = 2'b00;\n\
        \t\tMD = 0;\n\
        \t\tME = 0;\n\
        \t\tOP = 5'b00000;\n\
        \t\tInv = 0;\n\
        \t\tCR = 6'b000000;\n\
        \t\tN = 3'b011;\n\
        \t\tS = 3'b000;\n\
        \tend\n\
''')
fo.write("\tendcase")
fo.close()