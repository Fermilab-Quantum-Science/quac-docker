# docker build -t quac_deps:3.13 .

# Set up to work with the diagonalize branch

# Build the dependencies for QuaC
FROM continuumio/miniconda3

# Base
RUN apt-get update && apt-get install -y \
       gcc g++ gfortran texlive make valgrind

# Parameter for parallel build in make
ARG make_minus_j=6

# Get PETSc
RUN mkdir -p /quac
WORKDIR /quac
ENV PETSC_DIR=/quac/petsc
ENV PETSC_ARCH=linux-gnu-c-complex-int64-sprng
RUN git clone -b maint https://gitlab.com/petsc/petsc.git petsc && \
    cd petsc && \
    git checkout v3.13.3 && \
    ./configure --with-scalar-type=complex --download-mpich --download-fblaslapack=1 \
         --with-debugging=no COPTFLAGS=-O3 CXXOPTFLAGS=-O3 FOPTFLAGS=-O3 --with-64-bit-indices --download-sprng && \
    make -j ${make_minus_j} PETSC_DIR=${PETSC_DIR} PETSC_ARCH=${PETSC_ARCH} all

# Get SLEPc
ENV SLEPC_DIR=/quac/slepc
RUN git clone https://gitlab.com/slepc/slepc && \
    cd slepc && \
    git checkout v3.13.3 && \
    ./configure && \
    make -j ${make_minus_j} SLEPC_DIR=${SLEPC_DIR}

# Install some stuff into miniconda
RUN /opt/conda/bin/conda install -y numpy scipy scikit-learn matplotlib pandas h5py jupyter notebook jupyterlab && \
    /opt/conda/bin/pip install qiskit

# Expose Jupyter server
EXPOSE 8888

# Add to the path
ENV PATH ${PETSC_DIR}/${PETSC_ARCH}/bin:$PATH
ENV LD_LIBRARY_PATH ${PETSC_DIR}/${PETSC_ARCH}/lib:${SLEPC_DIR}/${PETSC_ARCH}/lib:$LD_LIBRARY_PATH