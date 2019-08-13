import csv
import json
import nltk
from nltk.stem.lancaster import LancasterStemmer
stemmer = LancasterStemmer()
import operator

ignore_words = ['?']
nn_width = 20

tags = {}

with open('chatbot/flights.json') as json_data:
    intents = json.load(json_data)
    dict = intents['intents']
    for item in dict:
        tags[item['tag']] = item['responses']

def saveToCSV(list, filename):
    with open(filename, 'w') as file:
        wr = csv.writer(file, delimiter=',', quoting=csv.QUOTE_MINIMAL)
        for row in list:
            wr.writerow([row])

def loadFromCSV(filename):
    data = []
    with open(filename, 'r') as file:
        rdr = csv.reader(file, quoting=csv.QUOTE_MINIMAL)
        for row in rdr:
            data.append(str(row).strip())
    return data

def loadFromFile(filename):
    data = []
    with open(filename, 'r') as file:
        for line in file:
            data.append(line.strip())
    return data

def convertToBag(text):
    words = []
    w = nltk.word_tokenize(text)
    words.extend(w)
    words = [stemmer.stem(w.lower()) for w in words if w not in ignore_words]
    lex = loadFromFile('chatbot/words.csv')
    bag = zeroList(len(lex))
    for word in words:
        if word in lex:
            #print(word, ' : ', lex.index(word))
            bag[lex.index(word)] = 1
    return bag

def zeroList(length):
    zeros = []
    for i in range(length):
        zeros.append(0)
    return zeros

def predictThis(model, sentence):
    response = ""
    classes = loadFromFile('chatbot/classes.csv')
    bag = convertToBag(sentence)
    bags = []
    bags.append(bag)
    preds = model.predict(bags)
    for i in range(len(preds)):
        index, value = max(enumerate(preds[i]), key=operator.itemgetter(1))
        accuracy = value*100
        print(sentence, ' : ', classes[index] , ' : ', (value*100), '%')
        tag = classes[index]

        accuracy
        if (accuracy < 50):
            response = "I don't understand, can you rephrase your question ?"
        else:
            responses = tags[tag]
            response = responses[0]

    return response
