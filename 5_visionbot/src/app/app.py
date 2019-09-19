import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)

from flask import Flask

app = Flask(__name__)
app.config.from_object('config')

import views
