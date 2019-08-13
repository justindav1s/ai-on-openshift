# things we need for NLP
import nltk
from nltk.stem.lancaster import LancasterStemmer
stemmer = LancasterStemmer()

# things we need for Tensorflow
import numpy as np
import tflearn
import tensorflow as tf
from tflearn.data_utils import to_categorical, pad_sequences
import random
import cb_utils
import operator

# import our chat-bot intents file
import json
with open('flights.json') as json_data:
    intents = json.load(json_data)

words = []
classes = []
sentences = []
ignore_words = ['?']
# loop through each sentence in our intents patterns
for intent in intents['intents']:
    for pattern in intent['patterns']:
        # tokenize each word in the sentence
        w = nltk.word_tokenize(pattern)
        # add to our words list
        words.extend(w)
        # add to documents in our corpus
        sentences.append((w, intent['tag']))
        # add to our classes list
        if intent['tag'] not in classes:
            classes.append(intent['tag'])

# stem and lower each word and remove duplicates
words = [stemmer.stem(w.lower()) for w in words if w not in ignore_words]
words = sorted(list(set(words)))

# remove duplicates
classes = sorted(list(set(classes)))

print (len(sentences), "sentences")
print (len(classes), "classes", classes)
print (len(words), "unique stemmed words", words)
cb_utils.saveToCSV(classes, 'classes.csv')
cb_utils.saveToCSV(words, 'words.csv')
cb_utils.saveToCSV(sentences, 'sentences.csv')

# create our training data
training = []
output = []
# create an empty array for our output
output_empty = [0] * len(classes)

# training set, bag of words for each sentence
for sentence in sentences:
    # list of tokenized words for the pattern
    pattern_words = sentence[0]
    classifier = sentence[1]
    # stem each word
    pattern_words = [stemmer.stem(word.lower()) for word in pattern_words if word not in ignore_words]
    # create our bag of words array
    encoded_sentence = []
    encoded_sentence.append(classes.index(classifier))
    for w in pattern_words:
        #print(w, ' : ', words.index(w))
        encoded_sentence.append(words.index(w))

    #print(encoded_sentence)
    training.append(encoded_sentence)

# shuffle our features and turn into np.array
random.shuffle(training)
training = np.array(training)

train_x = []
train_y = []
x_width = 10
for sample in training:
    train_y.append(sample[0])
    train_x.append(sample[1:])
    if len(sample[1:]) > x_width:
        x_width = len(sample[1:])

x_height = len(words)
y_width = len(classes)
hidden_width = 128
dropout = 0.8

trainX = pad_sequences(train_x, maxlen=x_width, value=0.)
trainY = to_categorical(train_y, nb_classes=9)

# reset underlying graph data
tf.reset_default_graph()
# Network building
net = tflearn.input_data([None, x_width])
net = tflearn.embedding(net, input_dim=x_height, output_dim=hidden_width)
net = tflearn.lstm(net, hidden_width, dropout=dropout)
net = tflearn.fully_connected(net, y_width, activation='softmax')
net = tflearn.regression(net, optimizer='adam', learning_rate=0.001,
                         loss='categorical_crossentropy')

# Training
model = tflearn.DNN(net, tensorboard_verbose=0)
model.fit(trainX, trainY, validation_set=0.2, show_metric=True, batch_size=3, n_epoch=100, shuffle=True, snapshot_epoch=True)

model.save('models/lstm_chatbot.model')

def saveNetProps(x_width, x_height, y_width):
    file = open('netprops.py', 'w')
    file.write('x_width='+str(x_width)+'\n')
    file.write('x_height='+str(x_height)+'\n')
    file.write('y_width='+str(y_width)+'\n')
    file.write('hidden_width='+str(hidden_width)+'\n')
    file.write('dropout='+str(dropout)+'\n')
    file.close()

saveNetProps(x_width, x_height, y_width)

