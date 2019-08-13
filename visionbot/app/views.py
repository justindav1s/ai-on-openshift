from flask import render_template, flash, redirect
from app import app
from forms import URLForm
from model import Image
import allcnn_predict



@app.route('/', methods=['GET', 'POST'])
def index():
    print ("1");
    form = URLForm()
    timg = Image("", "", "")
    if form.validate_on_submit():
        flash('Query=%s' %(form.query.data))
        print ("2");
        url = form.query.data
        print ("url : "+url);
        procImage = allcnn_predict.processImage(url)
        category, prob = allcnn_predict.predictImage(procImage)
        print ("category : "+category);
        print ("prob : "+prob);
        timg = Image(url, category, prob)
        timg.toString()

        return render_template("index.html",
                           title='VisionBot',
                           form=form,
                           image=timg)

    return render_template("index.html",
                           title='VisionBot',
                           form=form,
                           image=timg)
