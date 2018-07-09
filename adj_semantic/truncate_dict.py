import pymorphy2
import re
'''
Оставляет только прилагательные
'''

def check_line (line):
    new_line = ''
	
    word = re.findall("[А-Я]*", line)[0]
    if morph.parse(word)[0].tag.POS in ("ADJF","ADJS"):
        f_out.write(line+"\n")
    
f_in = open("abc.txt","r")
f_out = open("truncated.txt","w")
morph = pymorphy2.MorphAnalyzer()

text = f_in.read().split("\n")
for line in text:
	if line: check_line(line)
