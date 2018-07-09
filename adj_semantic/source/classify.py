import pymorphy2
import sqlite3
import re
from functools import reduce
import sys


def word_to_normal_form(word, POS):
    """ Проверяет, будет ли word частью речи POS и ставит в нормальную форму"""
    morph = pymorphy2.MorphAnalyzer()
    tags_word = morph.parse(word)
    parts_of_speech = {}
    for el in tags_word:
        if parts_of_speech.get(el.tag.POS) is None:  # Заполняем словарь вида {NOUN:sc,  VERB:sc ...}
            parts_of_speech[el.tag.POS] = el.score
        else:
            parts_of_speech[el.tag.POS] += el.score

    if not parts_of_speech.get(POS): parts_of_speech[POS] = 0
    POS_score = parts_of_speech.pop(POS)
    if parts_of_speech.values():
        if POS_score < reduce(lambda x, y: x + y,
                              parts_of_speech.values()):  # если score разборов по POS меньше остальных по score - это не сущ.
            del morph
            return False

    for el in tags_word:  # Возвращаем нормальную форму
        if POS in el.tag:
            del morph
            return el.normal_form



def parser(text=sys.argv[1]):
    infile = open(text, "r")
    pattern = u'[а-я]*\s-\s[а-я]*\s[а-я]*'
    sentences = re.findall(pattern, infile.read())

    infile.close()

    pattern = u'[А-Я]*[а-я]+'
    dictionary = {}

    for sent in sentences:
        sent = re.findall(pattern, sent)
        sent[1], sent[2] = word_to_normal_form(sent[1], 'ADJF'), word_to_normal_form(sent[2], 'NOUN')
        if sent[1] and sent[2]:
            if dictionary.get(sent[1]) is None:
                dictionary[sent[1]] = [sent[2]]
            else:
                dictionary[sent[1]].append(sent[2])

    return dictionary


conn = sqlite3.connect("../data/dictionary.db")
cursor = conn.cursor()
morph = pymorphy2.MorphAnalyzer()

for i in parser(sys.argv[1]).values():
    cursor.execute("SELECT result FROM Rules WHERE noun = '{word}'".format(word = i[0]))
    new_nouns = cursor.fetchall()

    cursor.execute("SELECT param,class FROM Nouns WHERE noun = '{word}'".format(word=i[0]))
    collocs = cursor.fetchall()

    # print (collocs)
    for j in range(len(collocs)):
        animacy = str(morph.parse(i[0])[0].tag.animacy)

        if animacy == 'inan':
            animacy = 0
        else:
            animacy = 1

        cursor.execute("SELECT word FROM Dict WHERE (params,anim) = ('{par}','{an}')".format(par = collocs[j][0], an = animacy))
        adjs = cursor.fetchall()
        # print (adjs)
        for k in adjs:
            if collocs[j][1] == 1: cl = "ИСТИННО"
            elif collocs[j][1] == 2: cl = "НЕ ОПРЕДЕЛЕНО"
            else: cl = "ЛОЖНО"
            print (k[0].lower() + " " + i[0] + " -> " + k[0].lower() + " " + new_nouns[0][0] + " " + cl)

conn.close()
