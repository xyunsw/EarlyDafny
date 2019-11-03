from flask import Blueprint, render_template, request
from backend import api

page = Blueprint('page', __name__, template_folder='templates')

@page.route('/')
def index():
    return render_template('index.html')


@page.route('/about')
def about():
    return render_template('about.html')


@page.route('/add_blood', methods=['GET', 'POST'])
def add_blood():
    if request.method == 'GET':
        return render_template('add_blood.html')
    else:
        api.add_blood(request.form)
        return render_template('add_blood.html', success=True)



