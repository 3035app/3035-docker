<img src="https://raw.githubusercontent.com/pia-lab/pialab/master/src/assets/images/pia-lab.png">

# How to setup a development environment

Make sure **Docker** and **docker-compose** are installed.

Clone the project `pialab/docker` in a working directory (`<pialab-root>`):

```
git clone ssh://git@git.pialab.io:2222/pialab/docker.git <pialab-root>
```

Clone the projects `pialab/back` and `pialab/front` into their respective source directories:

```
cd <piablab-root>
git clone ssh://git@git.pialab.io:2222/pialab/back.git ./back/src
git clone ssh://git@git.pialab.io:2222/pialab/front.git ./front/src
```

FIXME: We do have an issue with `composer install` on the backend. For now we have to manually copy the `vendor` directory into the Symfony source directory:
```
copy -R ./back/docker/vendor ./back/src/
```

Build the containers:
```
docker-compose build
```

Copy the backend development environment:

FIXME: Find a better solution!

```
copy ./back/docker/.env ./back/src/
```

Run the containers:
```
docker-compose up
```

Project URLs are:

* backend: http://back.pialab.localhost
* frontend: http://localhost:8080

FIXME: frontend URL should be http://front.pialab.localhost
