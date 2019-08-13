#!/usr/bin/env python
from __future__ import print_function
import numpy as np
import keras
from keras.models import model_from_json
from PIL import Image
import h5py
from urllib.request import urlopen
import tensorflow as tf
tf.logging.set_verbosity(tf.logging.ERROR)

model_json= "https://jndfiles-pub.s3-eu-west-1.amazonaws.com/models/allcnn_90_model.json"
model_weights= "https://jndfiles-pub.s3-eu-west-1.amazonaws.com/models/allcnn_90_weights.hdf5"
categories = ['airplane', 'automobile', 'bird', 'cat', 'deer', 'dog', 'frog', 'horse', 'ship', 'truck']

def loadModel(json_desc, weights):
    # load json and create model
    local_file='allcnn_model.json'
    modeldata = urlopen(model_json)
    modeltowrite = modeldata.read()

    with open(local_file, 'wb') as f:
        f.write(modeltowrite)

    json_file = open(local_file, 'r')
    loaded_model_json = json_file.read()
    json_file.close()

    loaded_model = model_from_json(loaded_model_json)

    # load weights into new model
    local_file='allcnn_weights.hdf5'
    weightdata = urlopen(weights)
    weightstowrite = weightdata.read()

    with open(local_file, 'wb') as f:
        f.write(weightstowrite)

    loaded_model.load_weights(local_file)
    return loaded_model

model = loadModel(model_json, model_weights)

def transformImage(image):
    data = np.reshape(image, (1, 32, 32, 3))
    data = data.astype('float32')
    data /= 255
    return data

def predictImage(image):
    imgarr = np.asarray(image)
    imaget = transformImage(imgarr)
    result = model.predict(imaget)
    result = result[0].tolist()
    best_index=result.index(max(result))
    best_prob = result[best_index]

    result[best_index] = 0
    sec_best_index=result.index(max(result))
    sec_best_prob = result[sec_best_index]

    result[sec_best_index] = 0
    thd_best_index=result.index(max(result))
    thd_best_prob = result[thd_best_index]

    category = str(categories[best_index])
    prob = '{:05.3f}'.format(best_prob)
    return category, prob

def processImage(url: str):
    img = Image.open(urlopen(url))
    img = img.resize((32, 32))
    return img;


url = "https://jndfiles-pub.s3-eu-west-1.amazonaws.com/images/cars/cars-21.jpg"
img = processImage(url)
category, prob = predictImage(img)
print ("1st prediction : "+category+" prob : "+prob)
