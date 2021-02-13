FROM python:3.8-alpine

# env - paths
ENV USER="app"
ENV GROUP="app"
ENV HOME="/home/$USER"
ENV PROJECT_HOME="$HOME/web"
ENV PATH="$HOME/env/bin:$PATH"
ENV VIRTUAL_ENV="$HOME/env"

# env - python tweeking
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# env - gunicorn
ENV GUNICORN_PORT=8000

# create directories
RUN mkdir "$HOME" "$PROJECT_HOME" "$PROJECT_HOME/static"

# include files
COPY ["requirements.txt", "$PROJECT_HOME/"]

# install packages
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
    && $HOME/env/bin/pip install --no-cache-dir -r "$PROJECT_HOME/requirements.txt" \
    && runDeps="$(scanelf --needed --nobanner --recursive $VIRTUAL_ENV \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u \
        | xargs -r apk info --installed \
        | sort -u)" \
    && apk add --virtual rundeps $runDeps \
    && apk del .build-deps \
    && chown -R "$USER:$GROUP" "$HOME"

# setup app
COPY ["*.py", "$PROJECT_HOME/"]
RUN chown "$USER:$GROUP" "$PROJECT_HOME/"*.py

# define app user
USER "$USER:$GROUP"

# set working directory
WORKDIR "$PROJECT_HOME"

# expose port
EXPOSE "$GUNICORN_PORT"

# start app
CMD ["python", "start.py"]
