#!/bin/sh

# migrations
python manage.py makemigrations
python manage.py migrate

# create admin
python manage.py createsuperuser --no-input

# set up static files
python manage.py collectstatic --no-input

# start gunicorn
gunicorn wsgi:application \
    --bind "0.0.0.0:8000" \
    --workers "${GUNICORN_WORKERS}" \
    --error-logfile -
