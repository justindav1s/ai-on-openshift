#!/usr/bin/python3
from app import app
import nltk

nltk.download('punkt')
nltk.download('wordnet')

app.run(host='0.0.0.0', port=8080, debug=True)
