<img src="https://raw.githubusercontent.com/pia-lab/pialab/master/src/assets/images/pia-lab.png">

# How to setup a development environment

* make sure **Docker** and **docker-compose** are installed
* clone the project `pialab/docker` in a working directory (`<pialab-root>`):  
```
git clone ssh://git@git.pialab.io:2222/pialab/docker.git <pialab-root>
```
* clone the projects `pialab/back` and `pialab/front` into their respective source directories:   
```
cd <piablab-root>
git clone ssh://git@git.pialab.io:2222/pialab/back.git ./back/src
git clone ssh://git@git.pialab.io:2222/pialab/front.git ./front/src
```

```
docker build . -t pialab-back:1644
docker build . -t pialab-front:1957
```
