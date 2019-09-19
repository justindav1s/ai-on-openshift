from flask_wtf import FlaskForm
from wtforms import StringField, BooleanField
from wtforms.validators import DataRequired

class URLForm(FlaskForm):
    query = StringField('query', validators=[DataRequired(), StringField])
