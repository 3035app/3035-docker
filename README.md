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
cp -R ./back/docker/vendor ./back/src/
```

Build the containers:

```
docker-compose build
```

Copy development environments:

FIXME: Find a better solution!

```
cp ./back/docker/.env ./back/src/
cp ./front/docker/environment.dev.ts ./front/src/src/environments/
```

Set rights for Symfony cache:

```
mkdir ./back/src/var
chmod 777 ./back/src/var
```

Run the containers:

```
docker-compose up
```

Project URLs are:

- backend: http://back.pialab.localhost (test/test)
- frontend: http://localhost:8080 (test/test)

FIXME: frontend URL should be http://front.pialab.localhost

Create an application in backend app:

- Go to http://back.pialab.localhost/login and login with test/test
- Go to "Applications" tab and add an application :
  - Nom : Default app
  - URL : http://localhost:8080
- On applications list, click on key icon of "Default app", copy "Client ID" and "Client Secret" and paste into front/src/src/envirnments/envirnment.dev.ts file
- Go to "Utilisateurs" tab, edit test user and add Application "Default app"
- Restart pialab_front container
