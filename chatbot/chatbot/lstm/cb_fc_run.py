import tflearn
import tensorflow as tf
import cb_utils
import json

words = cb_utils.loadFromFile('words.csv')
classes = cb_utils.loadFromFile('classes.csv')

# reset underlying graph data
tf.reset_default_graph()
# Build neural network
net = tflearn.input_data(shape=[None, len(words)])
net = tflearn.fully_connected(net, cb_utils.nn_width)
net = tflearn.fully_connected(net, cb_utils.nn_width)
net = tflearn.fully_connected(net, len(classes), activation='softmax')
net = tflearn.regression(net)

# Define model and setup tensorboard
model = tflearn.DNN(net)
model.load('models/airline_chatbot_model.tflearn')

cb_utils.predictThis(model, 'I would like to buy a ticket to London')
cb_utils.predictThis(model, 'what time is it')
cb_utils.predictThis(model, 'I need some help')
cb_utils.predictThis(model, 'whats the flight schedule between London and Manchester')
cb_utils.predictThis(model, 'When does the first flight depart')
cb_utils.predictThis(model, 'What time does the flight from London arrive')
cb_utils.predictThis(model, 'I would like a flight to New York please.')
cb_utils.predictThis(model, 'like York flight I would a to New please.')
cb_utils.predictThis(model, 'Thanks for you help.')
cb_utils.predictThis(model, 'Can I pay with a credit card ?')