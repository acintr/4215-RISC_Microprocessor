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

case = '''\t\t6'b{}:\t\t\t\t\t// STATE {}\n\
        \t\t\tbegin\n\
        \t\t\t\tFR = {};\n\
        \t\t\t\tRF = {};\n\
        \t\t\t\tIR = {};\n\
        \t\t\t\tMAR = {};\n\
        \t\t\t\tMDR = {};\n\
        \t\t\t\tReadWrite = {};\n\
        \t\t\t\tMOV = {};\n\
        \t\t\t\tMA = 2'b{};\n\
        \t\t\t\tMB = 2'b{};\n\
        \t\t\t\tMC = 2'b{};\n\
        \t\t\t\tMD = {};\n\
        \t\t\t\tME = {};\n\
        \t\t\t\tOP = 5'b{};\n\
        \t\t\t\tInv = {};\n\
        \t\t\t\tCR = 6'b{};\t// STATE {}\n\
        \t\t\t\tN = 3'b{};\t\t// {}\n\
        \t\t\t\tS = 3'b{};\n\
        \t\t\tend\n\
'''

fo = open(states, 'w')
fo.write("\tcase(state)\n")
for d in data:
    fo.write(case.format(bin(int(d[1])).replace("0b", ""), d[1],d[2], d[3], d[4], 
    d[5], d[6], d[7], d[8], d[9], d[10], d[11], d[12], 
    d[13], d[14], d[20], bin(int(d[22])).replace("0b", ""), d[22], d[19], d[23].replace("\n", ""), d[21]))

fo.write('''\t\t6'b000000:\t\t// STATE 0\n\
        \t\t\tbegin\n\
        \t\t\t\tFR = 0;\n\
        \t\t\t\tRF = 0;\n\
        \t\t\t\tIR = 0;\n\
        \t\t\t\tMAR = 0;\n\
        \t\t\t\tMDR = 0;\n\
        \t\t\t\tReadWrite = 0;\n\
        \t\t\t\tMOV = 0;\n\
        \t\t\t\tMA = 2'b00;\n\
        \t\t\t\tMB = 2'b00;\n\
        \t\t\t\tMC = 2'b00;\n\
        \t\t\t\tMD = 0;\n\
        \t\t\t\tME = 0;\n\
        \t\t\t\tOP = 5'b00000;\n\
        \t\t\t\tInv = 0;\n\
        \t\t\t\tCR = 6'b000000;\n\
        \t\t\t\tN = 3'b011;\n\
        \t\t\t\tS = 3'b000;\n\
        \t\t\tend\n\
''')
fo.write("\tendcase")
fo.close()