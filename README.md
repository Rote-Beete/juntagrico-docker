# Juntagrico Docker Container

Juntagrico is a management platform for community gardens and vegetable cooperatives. It is developed in [juntagrico](https://github.com/juntagrico)/[juntagrico](https://github.com/juntagrico/juntagrico).

## Build status

![Build Docker image](https://github.com/Rote-Beete/juntagrico-docker/workflows/Build%20Docker%20image/badge.svg)

## Getting Started

### Prerequisities

In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

Also, you need to have docker-compose available:

* [All systems](https://docs.docker.com/compose/install/)

### Usage

This repository contains a docker-compose configuration for starting a full
deployment of juntagrico.

To start the services call:

```console
docker-compose up --force-recreate --detach
```

Once everything has been started, you should be able to access juntagrico at
<http://localhost/>.

When you are done using juntagrico, don't forget to shutdown the services using:

```console
docker-compose down
```

### Known Issues

On first start, there is a race condition where juntagrico will crash
because Postgres is not yet ready when it attempts to run migrations.

To check if this is happening, you can view the logs of the instance using:

```console
docker-compose logs juntagrico
```

If you see any errors relating to Postges connection issues, try restarting
this container:

```console
docker-compose restart juntagrico
```

#### Container Images

To help users to get up and running fast, the docker-compose setup uses
an image that we publish to our [registry at DockerHub](https://hub.docker.com/r/rotebeete/juntagrico)
by default.

GitHub Actions are used to build these images.

The `latest` image is built from the `master` branch.

Images tagged `pr-XX` will be built for pull requests.

If you want to build an image locally for usage with the provided docker-compose
setup, use the following command:

```shell
docker build . -t rotebeete/juntagrico
```

Docker-compose will now use your locally generated image.

To return to the image from the registry use:

```shell
docker-compose pull
```

#### Environment Variables

* `DEBUG` (**1**) - Debug mode (1 is ON, 0 is OFF)
* `DJANGO_SUPERUSER_USERNAME` (**juntagrico**) - Name of the administrative Django user
* `DJANGO_SUPERUSER_PASSWORD` (**juntagrico**) - Password of the administrative Django user
* `DJANGO_SUPERUSER_EMAIL` (**juntagrico@localhost.localhost**) - Email of the administrative Django user
* `JUNTAGRICO_SECRET_KEY` (**juntagrico**) - A secret key for a particular Django installation. This is used to provide [cryptographic signing](https://docs.djangoproject.com/en/3.1/topics/signing/), and should be set to a unique, unpredictable value.
* `JUNTAGRICO_DATABASE_BACKEND` (**django.db.backends.sqlite3**) - Django database backend configuration. See [documentation](https://docs.djangoproject.com/en/3.1/ref/databases/) for different configuration possibilities
* `JUNTAGRICO_DATABASE_NAME` (**juntagrico.sqlite3**) - Name of the database
* `JUNTAGRICO_DATABASE_USER` - Database username (Not used for SQLite3)
* `JUNTAGRICO_DATABASE_PASS` - Database password (Not used for SQLite3)
* `JUNTAGRICO_DATABASE_HOST` - Database Host (Not used for SQLite3)
* `JUNTAGRICO_DATABASE_PORT` - Database Port (Not used for SQLite3)
* `JUNTAGRICO_EMAIL_HOST` (**localhost**) - SMTP host to use for mail sending
* `JUNTAGRICO_EMAIL_USER` (**juntagrico@localhost.localhost**) - SMTP username
* `JUNTAGRICO_EMAIL_PASS` (**secret**) - SMTP password
* `JUNTAGRICO_EMAIL_PORT` (**587**) - SMTP port
* `JUNTAGRICO_EMAIL_TLS` (**true**) - Should be true for privacy reasons
* `JUNTAGRICO_FQDN` (**localhost**) - FQDN which is added to Django's ALLOWD_HOSTS list
* `GUNICORN_PORT` (**8000**) - Port the gunicorn webserver will listen on

#### Volumes

* `/home/app/web/static` - Static web files (Images, CSS, JS, ... )

## Built With

* Juntagrico 1.3.7
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
