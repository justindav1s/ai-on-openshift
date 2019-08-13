import tflearn
import tensorflow as tf
import cb_utils
import json

words = cb_utils.loadFromFile('../chatbot/words.csv')
classes = cb_utils.loadFromFile('../chatbot/classes.csv')

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
model.load('../chatbot/models/airline_chatbot_model.tflearn')

cb_utils.predictThis(model, 'are you open')
cb_utils.predictThis(model, 'you open')
cb_utils.predictThis(model, 'when do you open')
cb_utils.predictThis(model, 'what time do you open')
cb_utils.predictThis(model, 'what can I hire from you')

if __name__ == '__main__':
    tags = {}
    with open('flights.json') as json_data:
        intents = json.load(json_data)
        dict = intents['intents']
        for item in dict:
            tags[item['tag']] = item['responses']

    for i in range(10):
        query = input("?\n")
        tag, accuracy = cb_utils.predictThis(model, query)
        if (accuracy > 50):
            print("I don't understand can you rephrase your question.")
        else:
            responses = tags[tag]
            print(responses[0])