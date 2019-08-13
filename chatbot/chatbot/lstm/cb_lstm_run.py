import tflearn
import tensorflow as tf
import cb_utils
import json
from tflearn.data_utils import pad_sequences
import nltk
from nltk.stem.lancaster import LancasterStemmer
stemmer = LancasterStemmer()
import operator
import netprops

words = cb_utils.loadFromFile('words.csv')
classes = cb_utils.loadFromFile('classes.csv')

def predictThis(model, sentence):
    ignore_words = ['?']
    pattern_words = nltk.word_tokenize(sentence)
    # stem each word
    pattern_words = [stemmer.stem(word.lower()) for word in pattern_words if word not in ignore_words]
    encoded_sentence = []
    for w in pattern_words:
        if w in words:
            #print(w, ' : ', words.index(w))
            encoded_sentence.append(words.index(w))

    #print(encoded_sentence)
    samples = []
    samples.append(encoded_sentence)

    samples = pad_sequences(samples, maxlen=netprops.x_width, value=0.)
    preds = model.predict(samples)
    index, value = max(enumerate(preds[0]), key=operator.itemgetter(1))
    print(sentence, ' : ', classes[index] , ' : ', (value*100), '%')



# reset underlying graph data
tf.reset_default_graph()
# Build neural network
net = tflearn.input_data([None, netprops.x_width])
net = tflearn.embedding(net, input_dim=netprops.x_height, output_dim=netprops.hidden_width)
net = tflearn.lstm(net, netprops.hidden_width, dropout=netprops.dropout)
net = tflearn.fully_connected(net, netprops.y_width, activation='softmax')
net = tflearn.regression(net, optimizer='adam', learning_rate=0.001,
                         loss='categorical_crossentropy')

# Define model and setup tensorboard
model = tflearn.DNN(net)
model.load('models/lstm_chatbot.model')

predictThis(model, 'I would like to buy a ticket to London')
predictThis(model, 'what time is it')
predictThis(model, 'I need some help')
predictThis(model, 'whats the flight schedule between London and Manchester')
predictThis(model, 'When does the first flight depart')
predictThis(model, 'What time does the flight from London arrive')
predictThis(model, 'I would like a flight to New York please.')
predictThis(model, 'like York flight I would a to New please.')
predictThis(model, 'Thanks for you help.')
predictThis(model, 'Can I pay with a credit card ?')