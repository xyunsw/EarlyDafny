from flask import Flask, render_template
from werkzeug.contrib.fixers import ProxyFix
import os
from route import page, api
t
app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app)

app.register_blueprint(page)

app.debug = True

if not app.debug or os.environ.get("WERKZEUG_RUN_MAIN") == "true":
    api.start_level_checking()


