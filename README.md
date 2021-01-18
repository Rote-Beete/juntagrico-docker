# Juntagrico Docker Container

This container includes [juntagrico](https://github.com/juntagrico)/[juntagrico](https://github.com/juntagrico/juntagrico), a management platform for community gardens and vegetable cooperatives.

## Build status

![Build Docker image](https://github.com/Rote-Beete/juntagrico-docker/workflows/Build%20Docker%20image/badge.svg)

## Getting Started

### Prerequisities

In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

### Usage

This docker image is only serving the application via (gunicorn)[https://gunicorn.org/]. Please have a look at [Rote-Beete](https://github.com/Rote-Beete)/[juntagrico-compose](https://github.com/Rote-Beete/juntagrico-compose) in order to spawn a full application mesh, including (nginx)[https://www.nginx.com/] for serving static files, as well as (traefik)[https://doc.traefik.io/traefik/] as reverse proxy.


#### Container Parameters

start juntagrico

```shell
docker run -v "${PWD}":/work:ro rotebeete/ansible playbook.yml
```

lint playbook

```shell
docker run --entrypoint ansible-lint -v "${PWD}":/work:ro rotebeete/ansible playbook.yml
```

#### Environment Variables

# env - app
* `DEBUG` (1) - Debug mode (1 is ON, 0 is OFF)
* `DJANGO_SUPERUSER_USERNAME` ("juntagrico") - Name of the administrative Dajngo user
* `DJANGO_SUPERUSER_PASSWORD` ("juntagrico") - Password of the administrative Dajngo user
* `DJANGO_SUPERUSER_EMAIL` ("juntagrico@loclahost.loclahost") - Email of the administrative Dajngo user
* `JUNTAGRICO_SECRET_KEY` ("juntagrico") - A secret key for a particular Django installation. This is used to provide [cryptographic signing](https://docs.djangoproject.com/en/3.1/topics/signing/), and should be set to a unique, unpredictable value.
* `JUNTAGRICO_DATABASE_BACKEND` ("django.db.backends.sqlite3") - Django database backend configuration. See [documentation](https://docs.djangoproject.com/en/3.1/ref/databases/) for different configuration possibilities
* `JUNTAGRICO_DATABASE_NAME` ("juntagrico.sqlite3") - Name of the database
* `JUNTAGRICO_DATABASE_USER` ("") - Database username (Not used for SQLite3)
* `JUNTAGRICO_DATABASE_PASSWORD` ("") - Database password (Not used for SQLite3)
* `JUNTAGRICO_DATABASE_HOST` ("") - Database Host (Not used for SQLite3)
* `JUNTAGRICO_DATABASE_PORT` ("") - Database Port (Not used for SQLite3)
* `JUNTAGRICO_EMAIL_HOST` ("localhost") - SMTP host to use for mail sending
* `JUNTAGRICO_EMAIL_USER` ("juntagrico@loclahost.loclahost") - SMTP username
* `JUNTAGRICO_EMAIL_PASSWORD` ("secret") - SMTP password
* `JUNTAGRICO_EMAIL_PORT` (587) - SMTP port
* `JUNTAGRICO_EMAIL_TLS` ("true") - Should be true for privacy reasons
* `GUNICORN_PORT` ("8000") - Port the gunicorn webserver will listen to

#### Volumes

* `/home/app/web/static` - Static web files (Images, CSS, JS, ... )

## Built With

* Juntagrico 1.3.3
* gunicorn 20.0.4
* psycopg2 2.8.6

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the
[tags on this repository](https://github.com/Rote-Beete/juntagrico-docker/tags).

## Authors

* **Michael Gerlach** - *Initial work* - [n3ph](https://github.com/n3ph)

See also the list of [contributors](https://github.com/Rote-Beete/juntagrico-docker/contributors) who
participated in this project.

## License

This project is licensed under the AGPL License - see the [LICENSE.md](LICENSE.md) file for details.
