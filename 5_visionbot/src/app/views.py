from flask import render_template, flash, redirect
from app import app
from forms import URLForm
from model import Image
from model import BotError
import urllib
from urllib.error import HTTPError
import allcnn_predict

@app.route('/', methods=['GET', 'POST'])
def index():
    form = URLForm()
    timg = Image(False, "", "", "")
    botError = BotError(False, "")
    if form.validate_on_submit():

        url = form.query.data

        try :
            # resize image to 32x32 pixel image
            procImage = allcnn_predict.processImage(url)
            # transform to 32,32,3 matrix, feed to model
            category, prob = allcnn_predict.predictImage(procImage)

            timg = Image(True, url, category, prob)
            timg.toString()
        except ValueError as e:
            print(e)
            botError = BotError(True, e)
        except urllib.error.HTTPError as e:
            print(e.msg)
            botError = BotError(True, e.msg)

        return render_template("index.html",
                           title='VisionBot',
                           form=form,
                           botError=botError,
                           image=timg)

    return render_template("index.html",
                           title='VisionBot',
                           form=form,
                           botError=botError,
                           image=timg)
