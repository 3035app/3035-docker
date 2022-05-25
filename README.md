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
- adminer: http://adminer.pialab.localhost

FIXME: frontend URL should be http://front.pialab.localhost

Create an application in backend app:

- Go to http://back.pialab.localhost/login and login with test/test
- Go to "Applications" tab and add an application :
  - Nom : Default app
  - URL : http://localhost:8080
- On applications list, click on key icon of "Default app", copy "Client ID" and "Client Secret" and paste into front/src/src/environments/environment.dev.ts file
- Go to "Utilisateurs" tab, edit test user and add Application "Default app"
- Restart pialab_front container

## `.env` parameters

Create 2 parameters in `.env` file.

as following:

- `FRONT_URL_ENV=http://localhost:8080`
- `APP_ENV=dev`

# Gitlab management

To summarize, there are 3 git repositories:

- docker (https://git.pialab.io/pialab/docker) for global dev environment
- Front (https://git.pialab.io/pialab/front) for frontent app (Angular)
- back (https://git.pialab.io/pialab/back) for backend app (Symfony)

These 3 repositories are independent, they need to be managed individually

# Database remote connection

In order to connect to the development database (using Adminer for example), the following settings must be used:

- System: **PostgreSQL**
- Server: **back**
- User: **user_pialab**
- Password: **password_pialab**
- Database: **db_pialab**

# Deployment with Ansible

Ensure installed Ansible version is greater than 2.11.

## install ansible dependencies

```
# you must be inside the ansible folder
cd deploy/ansible
ansible-galaxy install -r ./requirements.yml
```

## deploy

`./deploy.sh staging [fast]`

# Troubleshooting

## PostgreSQL connection fails

The container **pialab_back** is started but the PostgreSQL database is not, and logs contain:

```
2022-05-04 14:12:31.680 UTC [82] LOG:  invalid resource manager ID in primary checkpoint record
2022-05-04 14:12:31.680 UTC [82] PANIC:  could not locate a valid checkpoint record
2022-05-04 14:12:32.128 UTC [81] LOG:  startup process (PID 82) was terminated by signal 6: Aborted
2022-05-04 14:12:32.128 UTC [81] LOG:  aborting startup due to startup process failure
2022-05-04 14:12:32.152 UTC [81] LOG:  database system is shut down
pg_ctl: could not start server
```

* connect as root on the server
* do a backup of the database volume:
```
root@debian-2gb-hel1-1:/home/pialab/pialab/current# docker run --rm --volumes-from pialab_back -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /var/lib/postgresql
```
* get the container ID for **pialab_back**:
```
root@debian-2gb-hel1-1:/home/pialab/pialab/current# docker ps
```
* connect onto the container using its ID:
```
root@debian-2gb-hel1-1:/home/pialab/pialab/current# docker exec -it [CONTAINER_ID] /bin/bash
```
* switch onto `postgres` user:
```
root@[CONTAINER_ID]:/var/www/pialab-back# su postgres
```
* try to fix issues on data files:
```
postgres@[CONTAINER_ID]:/var/www/pialab-back$ /usr/lib/postgresql/11/bin/pg_resetwal -f /var/lib/postgresql/11/main/
```
* exit and restart the PostgreSQL service as root:
```
postgres@[CONTAINER_ID]:/var/www/pialab-back$ exit
root@[CONTAINER_ID]:/var/www/pialab-back# service postgresql start
```
