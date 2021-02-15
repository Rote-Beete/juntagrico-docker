FROM python:3.8-alpine3.13 AS base

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
    && addgroup -g 1000 -S "$GROUP" && adduser -u 1000 -S -G "$GROUP" "$USER" \
    && apk add --update --no-cache --virtual .build-deps \
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

FROM base AS development

# We are intentionally keeping root privileges here to be able to fix permissions
# of the bind mounts.
#
# We drop them later in the entrypoint.
USER 0

RUN set -eux \
    && apk add --update --no-cache runuser

COPY entrypoint-dev.sh /entrypoint-dev.sh

ENTRYPOINT ["/entrypoint-dev.sh"]

VOLUME "$PROJECT_HOME"

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

FROM base AS production
