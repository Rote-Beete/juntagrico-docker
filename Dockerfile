FROM python:3.8-alpine

# env - paths
ENV USER="app"
ENV GROUP="app"
ENV HOME="/home/$USER"
ENV APP_HOME="$HOME/web"
ENV PATH="$HOME/env/bin:$PATH"
ENV VIRTUAL_ENV="$HOME/env"

# env - python tweeking
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# env - app
ENV DEBUG=1
ENV DJANGO_ALLOWED_HOSTS="localhost 127.0.0.1 [::1]"
ENV DJANGO_SUPERUSER_USERNAME="juntagrico"
ENV DJANGO_SUPERUSER_PASSWORD="juntagrico"
ENV DJANGO_SUPERUSER_EMAIL="juntagrico@loclahost.loclahost"
ENV JUNTAGRICO_SECRET_KEY="juntagrico"
ENV JUNTAGRICO_DATABASE_NAME="juntagrico"
ENV JUNTAGRICO_DATABASE_USER="juntagrico"
ENV JUNTAGRICO_DATABASE_PASSWORD="juntagrico"
ENV JUNTAGRICO_DATABASE_HOST="db"
ENV JUNTAGRICO_EMAIL_HOST="localhost"
ENV JUNTAGRICO_EMAIL_USER="juntagrico@loclahost.loclahost"
ENV JUNTAGRICO_EMAIL_PASSWORD="secret"
ENV JUNTAGRICO_EMAIL_PORT=587
ENV JUNTAGRICO_EMAIL_TLS="true"

# env - gunicorn
GUNICORN_WORKERS=2

# create directories
RUN mkdir "$HOME" "$APP_HOME" "$APP_HOME/static"

# include files
COPY ["*.py", "requirements.txt", "$APP_HOME/"]
COPY ./entrypoint.sh /

# setup app
RUN set -eux \
    && addgroup -S "$GROUP" && adduser -S -G "$GROUP" "$USER" \
    && apk add --no-cache --virtual .build-deps \
        build-base \
        gcc \
        jpeg-dev \
        libpq \
        musl-dev \
        postgresql-dev \
        python3-dev \
        zlib-dev \
    && python -m venv "$VIRTUAL_ENV" \
    && $HOME/env/bin/pip install --no-cache-dir --upgrade pip \
    && $HOME/env/bin/pip install --no-cache-dir -r "$APP_HOME/requirements.txt" \
    && runDeps="$(scanelf --needed --nobanner --recursive $VIRTUAL_ENV \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u \
        | xargs -r apk info --installed \
        | sort -u)" \
    && apk add --virtual rundeps $runDeps \
    && apk del .build-deps \
    && chown -R "$USER:$GROUP" "$HOME"

# define app user
USER "$USER"

# set working directory
WORKDIR "$APP_HOME"

# expose port
EXPOSE 8000

# start
ENTRYPOINT ["/entrypoint.sh"]
