from flask import Blueprint, render_template, request, redirect, url_for, Response
from backend import api
import json

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
        print(blood_types)
        return render_template('request_blood.html', blood_types=blood_types.keys())
    else:
        data = {"blood_type": request.form['blood_type'], "n_bags": request.form['n_bags']}
        org = {"name": request.form['org_name'], "address": request.form['org_address'], "phone": request.form['org_phone']}
        data['org'] = org
        res = api.request_blood(data)
        if not res['success']:
            return render_template('error.html', err_msg=res['msg'])
        else:
            return "success"

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


@page.route('/request/<id>', methods=['GET'])
def show_request(id: str):
    res = api.get_request_by_id({'id': id})
    if not res['success']:
        return render_template('error.html', err_msg=res['msg'])
    else:
        return render_template('request.html', bloods=res['bloods'], org=res['org'])


@page.route('/blood_inventory')
def blood_inventory():
    return render_template('blood_inventory.html')


@page.route('/api/get_bloods_by_conditions', methods=['POST'])
def get_bloods_by_conditions():
    bloods = api.get_bloods_by_conditions(request.json)
    bloods = bloods['bloods']
    bloods = json.dumps(bloods)
    res = Response(bloods, 200, content_type="application/json")
    return res


