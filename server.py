from flask import Flask, render_template
from werkzeug.contrib.fixers import ProxyFix

from route import page

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app)

app.register_blueprint(page)




