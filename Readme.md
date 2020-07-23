# Docker for Quac
Adam Lyon, October 2019

## Introduction

Docker is useful easily installing libraries and packages. In this case, we use a docker installation for the dependencies of `Quac`, namely, `python`, `PetSc` and `SLEPc`. Furthermore, a mini-conda installation of `python` is included with `Jupyter`. The `quac_deps` image has these components. 

There is also  a `quac_deps_vnc` image that is based on the above and will serve VNC for a full linux desktop experience.

Note that these images do not contain `Quac` or `hep_quac` themselves. It is assumed you will check out those repositories. The images have the dependences that are hard to install and change less often.  

## Building the images

You can easily build the containers, though it may take awhile. I assume you already have `docker` installed on your machine and this repository checked out.

```bash
cd hep_quac/docker/quac-deps
docker build -t quac_deps .

# If you want the VNC image...
cd ../quac-deps-vnc
docker build -t quac_deps_vnc
```

## Running containers/services

The easiest way to run containers or start services is to use `docker-compose`. See the `hep_quac/docker/compose` directory. The `docker-compose.yml` file within defines two "services". 

For maximum performance, the `docker-compose.yml` has a set up for mounting your Mac home directory into the container with `nfs`. I've found this to be much more performant than using the Docker-for-Mac mechanism for binding directories. You can change the file to do what you want. If you choose to use `nfs` as it is set up, you will need to prepare your Mac. See [instructions](https://github.com/lyon-fnal/devenv/blob/master/README.md#prepare-nfs). 

An external volume is used for `/root`, so files there will be retained from session to session. 

Note that `Quac` depencencies are in the `/quac` directory. The environment, including `PATH` and `LD_LIBRARY_PATH`, will be set correctly when you enter the container.  

Note that you must be in the `hep_quac/docker/compose` directory to run `docker-compose` commands. Alternatively, you can use the `-f` option to give the location of the `docker-compose.yml` file. 

### Running the regular `quac` container

You will typically run things in the `Quac` environment in an ephemeral container (e.g. not a long lived service). Here are some examples,

```bash
# Connect to a shell
docker-compose run --rm quac /bin/bash

# Run python and exit when done
docker-compose run --rm -w /Users/lyon/Development/Quantum/Quac/hep_quac quac python run_vqe.py

# Run Jupyter lab. Connect from host with https://localhost:8888
docker-compose run --rm -w /Users/lyon/Development/Quantum/Quac/hep_quac --service-ports quac jupyter lab --ip=0.0.0.0 --allow-root --no-browser
```

### Running the VNC container

If you want a full Linux desktop experience, do

```bash
docker-compose up -d quac-vnc
```

Then use your VNC viewer on your host and connect to port `5902`. The password is `password` (so long as you use `127.0.0.1` in the port mapping, you should be safe). 

See [instructions](https://github.com/lyon-fnal/devenv#connecting-to-the-container-with-vnc) from a different project for running a VNC viewer on your mac. Note that the port in this case is `5902`.  