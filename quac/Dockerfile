# docker build -t quac:diagonalize .

# Set up to work with the diagonalize branch

# Build the dependencies for QuaC
FROM quac_deps:3.13

RUN apt-get update 

RUN git clone -b diagonalize https://github.com/0tt3r/QuaC && \
	cd QuaC && \
	make test
