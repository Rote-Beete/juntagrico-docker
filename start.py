#!/usr/bin/env python

# imports
from django import setup as django_setup
from django.core.management import base, call_command
from gunicorn.app.base import Application as app
from gunicorn import util
from multiprocessing import cpu_count
from os import environ
from pathlib import Path as path

# gunicorn class


class gunicorn(app):

    def __init__(self, options={}):
        self.options = options
        self.application = app
        super().__init__()

    def load_config(self):
        config = {key: value for key, value in self.options.items()
                  if key in self.cfg.settings and value is not None}
        for key, value in config.items():
            self.cfg.set(key.lower(), value)

    def load(self):
        return util.import_app("wsgi")

# execution
if __name__ == "__main__":

    # context
    BASE_DIR = path(__file__).resolve().parent.parent

    # load settings
    environ.setdefault("DJANGO_SETTINGS_MODULE", "settings")
    django_setup()

    # migrations
    call_command("makemigrations", interactive=False)
    call_command("migrate", interactive=False)

    # create admin
    try:
        call_command("createsuperuser", interactive=False)
    except base.CommandError as err:
        print('Createsuperuser Exception: ', err)

    # set up static files
    call_command("collectstatic", interactive=False)

    # start gunicorn
    options = {
        'bind': '%s:%s' % ('0.0.0.0', environ.get('GUNICORN_PORT')),
        'error-logfile': '-',
        'log-level': 'debug',
        'workers': (cpu_count() * 2) + 1,
    }

    gunicorn(options).run()
