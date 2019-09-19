#!/bin/bash

cd app

FLASK_APP=app.py
flask run --host=0.0.0.0 --port=8080
