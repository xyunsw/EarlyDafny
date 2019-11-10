from flask import Blueprint, render_template, request, redirect, url_for
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

@page.route('/request_blood', methods=['GET', 'POST'])
def request_blood():
    if request.method == 'GET':
        res = api.get_blood_public_info()
        blood_types = res['blood_types']
        return render_template('request_blood.html', blood_types=blood_types.keys())
    else:
        raise NotImplementedError()

@page.route('/blood/<bid>', methods=['GET', 'POST'])
def blood(bid: str):
    if request.method == 'GET':
        res = api.get_blood_by_id({"id": bid})
        if not res['success']:
            return render_template('error.html', err_msg=res['msg'])
        else:
            return render_template('blood.html', bid=bid, info=res)
    else:
        form = dict(request.form)
        form['id'] = bid
        api.update_blood(form)
        return redirect(url_for('page.blood', bid=bid))



