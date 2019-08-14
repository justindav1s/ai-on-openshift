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
    print ("1");
    form = URLForm()
    timg = Image(False, "", "", "")
    botError = BotError(False, "")
    if form.validate_on_submit():
        flash('Query=%s' %(form.query.data))
        print ("2");
        url = form.query.data
        print ("url : "+url);

        try :
            procImage = allcnn_predict.processImage(url)
            category, prob = allcnn_predict.predictImage(procImage)
            print ("category : "+category);
            print ("prob : "+prob);
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
