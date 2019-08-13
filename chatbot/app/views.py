from flask import render_template, flash, redirect
from app import app
from .forms import ChatForm
from .model import Exchange

conversation = []

import tflearn
import tensorflow as tf
from chatbot import cb_utils

words = cb_utils.loadFromFile('chatbot/words.csv')
classes = cb_utils.loadFromFile('chatbot/classes.csv')

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
model.load('chatbot/models/airline_chatbot_model.tflearn')

botname = 'Lissa'
@app.route('/', methods=['GET', 'POST'])
def index():
    form = ChatForm()
    if form.validate_on_submit():
        flash('Query=%s' %(form.query.data))
        ex = Exchange('You', form.query.data)
        conversation.append(ex)
        response = cb_utils.predictThis(model, form.query.data)
        ex = Exchange(botname, response)
        conversation.append(ex)
        return redirect('/')
    return render_template("index.html",
                           title='Chat',
                           form=form,
                           conversation=conversation)