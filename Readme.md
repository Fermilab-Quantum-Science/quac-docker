# Docker for Quac
Adam Lyon, July 2020

## Easy getting started

To get started quickly without cloning this whole repository, you can simply download the [compose/docker-compose.yml](https://raw.githubusercontent.com/Fermilab-Quantum-Science/quac-docker/master/compose/docker-compose.yml) file to a directory. Then, from that directory, run the command 
```
docker-compose run --rm quac /bin/bash
```

That should download the image from Docker Hub (may take awhile) if you don't already have it. 

## Introduction

Docker is useful easily installing libraries and packages. In this case, we use a docker installation for `QuaC` and its dependencies, namely `python`, `PetSc` and `SLEPc`. Furthermore, a mini-conda installation of `python` is included with `Jupyter`.

Currently, this branch (`main`) builds the `diagonalize` branch of QuaC at its dependencies. 

There is a `docker-compose` file in the `compose` directory that is set up to make QuaC easy to run on a Mac using the `lyonfnal/quac:diagonalize` image at Docker Hub. That's the easiest way to get started. 
 
## Building the images

Only build the images if you want to make changes and not use the image on Docker Hub. Normally, the Docker Hub image should be fine. See above. 

```bash
cd quac-docker/quac-deps
docker build -t quac_deps:3.13 .

cd ../quac
docker build -t quac:diagonalize
```

Note that you will need to change `compose/docker-compose.yml` to remove the `lyonfnal/` from the `quac` image name. 

## Running containers/services

The easiest way to run containers or start services is to use `docker-compose`. See the `compose/docker-compose.yml` file. This file is meant for running QuaC on a Mac. 

For maximum performance, the `docker-compose.yml` has a set up for mounting your Mac home directory into the container with `nfs`. I've found this to be much more performant than using the Docker-for-Mac mechanism for binding directories. You will need to prepare your Mac. See [instructions](https://github.com/lyon-fnal/devenv/blob/master/README.md#52-prepare-nfs-on-your-mac). You may need to scroll down a little until you see "5.2 Prepare NFS on your Mac".

An external volume is used for `/root`, so files there will be retained from session to session. 

Note that `Quac` and depencencies are in the `/quac` directory. The environment, including `PATH` and `LD_LIBRARY_PATH`, will be set correctly when you enter the container.  

Note that you must be in the `quac-docker/compose` directory to run `docker-compose` commands. Alternatively, you can use the `-f` option to give the location of the `docker-compose.yml` file. 

### Running the regular `quac` container

You will typically run things in the `Quac` environment in an ephemeral container (e.g. not a long lived service). Here are some examples,

```bash
# Connect to a shell
docker-compose run --rm quac /bin/bash

# Run Jupyter lab. Connect from host with https://localhost:8888
docker-compose run --rm -w <YOUR_DIRECTORY> --service-ports quac jupyter lab --ip=127.0.0.1 --allow-root --no-browser
```

Note that any changes you make in the `/quac` directory (e.g. to QuaC itself or its dependencies) will **not** be retained if stop and re-start the container. Your code should be in a volume that is mounted into the container (the `/root` directory is retained, so you can put stuff there - or somewhere in `/Users`).  If you want to make changes to QuaC itself, then you should clone QuaC to a mounted volume and build the dependency image and run that. 

## Building your code against QuaC

QuaC doesn't use libraries, so to build your application against QuaC, you need a `Makefile` with the right stuff. The [example](example/) directory has a sample application (from the QuaC example directory) and such a `Makefile`. Here is what you can do...

```
# Start the quac container. All commands are from within that container. 
# Make your browser window wide to see the whole line
cd /root   # Go to home area
mkdir myQuac ; cd myQuac   # Make a new directory

# Download the Makefile and sample application source code from Github
wget https://raw.githubusercontent.com/Fermilab-Quantum-Science/quac-docker/master/example/Makefile
wget https://raw.githubusercontent.com/Fermilab-Quantum-Science/quac-docker/master/example/simple_circuit.c

# Make an obj directory to store object files
mkdir obj

# Build
make simple_circuit

# Try it
./simple_circuit
```

To build your own application, look in [example/Makefile](example/Makefile) and replace `simple_circuit` with the name of your application and make the necessary alterations to the instructions above. 
