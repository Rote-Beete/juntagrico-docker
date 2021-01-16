FROM python:3.8-alpine

# set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV HOME=/home/app
ENV APP_HOME=$HOME/web
ENV VIRTUAL_ENV=$HOME/env
ENV PATH=$HOME/env/bin:$PATH

# create directories
RUN mkdir $HOME $APP_HOME $APP_HOME/static

# include files
COPY ["*.py", "requirements.txt", "$APP_HOME/"]

# setup app
RUN set -ex \
    && addgroup -S app && adduser -S -G app app \
    && apk add --no-cache --virtual .build-deps build-base gcc jpeg-dev libpq musl-dev postgresql-dev python3-dev zlib-dev \
    && python -m venv $HOME/env \
    && $HOME/env/bin/pip install --no-cache-dir --upgrade pip \
    && $HOME/env/bin/pip install --no-cache-dir -r $APP_HOME/requirements.txt \
    && runDeps="$(scanelf --needed --nobanner --recursive $HOME/env \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u \
        | xargs -r apk info --installed \
        | sort -u)" \
    && apk add --virtual rundeps $runDeps \
    && apk del .build-deps \
    && chown -R app:app $HOME

# define app user
USER app

# set working directory
WORKDIR $APP_HOME

# Expose port
EXPOSE 8000
