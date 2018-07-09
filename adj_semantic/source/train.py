import pymorphy2
import re
import sqlite3
import random
import sys
from functools import reduce

"""
Данная программа обучает класификатор
Входной текст - аргумент командной строки
Вывод происходит в БД ../data/dictionary.db
"""


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


# infile - исходный текст

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


def choose_word(words):
    """words = [(),(),(),...]"""
    return words[random.randint(0, len(words) - 1)][0]


def construct_colloc(noun):
    """ конструирует словосочетания для опроса. Прилагательные выбираются случайно с учётом одушевленности"""
    morph = pymorphy2.MorphAnalyzer()
    anim = str(morph.parse(noun[0])[0].tag.animacy)
    del morph

    if anim == 'inan':
        anim = 0
    else:
        anim = 1

    collocs = []
    cursor.execute("SELECT MAX(id) FROM Metaparams")
    params_num = cursor.fetchall()[0][0]
    for i in range(params_num):
        cursor.execute("SELECT param FROM Metaparams WHERE id = {n}".format(n=i + 1))
        param = cursor.fetchall()[0][0]
        cursor.execute(
            "SELECT word FROM Dict WHERE (params,anim) = ('{par}','{animacy}')".format(par=param, animacy=anim))
        words = cursor.fetchall()

        if not words: continue

        collocs.append((choose_word(words), noun[0]))
    return collocs


conn = sqlite3.connect("../data/dictionary.db")
cursor = conn.cursor()

for j in list(parser(sys.argv[1]).values()):

    cursor.execute("SELECT result FROM Rules WHERE noun = '{word}'".format(word = j[0]))
    new_word = cursor.fetchall()[0][0]

    for i in construct_colloc(j):
        print(i[0].lower() + " " + i[1] + " -> " + i[0].lower() + " " + new_word)
        Class = int(input())
        if not Class: continue
        cursor.execute("SELECT params FROM Dict WHERE word = '{adj}'".format(adj=i[0]))
        param = cursor.fetchall()[0][0]
        cursor.execute("INSERT INTO Nouns VALUES ('{noun}','{par}','{cl}')".format(noun=i[1], par=param, cl=Class))

conn.commit()
conn.close()

# print(construct_colloc(list(parser(sys.argv[1]).values())[0]))
