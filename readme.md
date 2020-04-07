# Readme

Compile FreeSurfer on ppc64.  

Using the docker container in this repo, which compiles itk 4.13 from source and mostly following along [here](https://github.com/corticometrics/fs-docker) with minor modifications to the [FreeSurfer dev branch](https://github.com/pwighton/freesurfer/tree/20191115-ppc64) which
  - disable the compilation of `mri_watershed`
    - this is the only binary that includes `affine.hpp` which seems hard coded to x86
  - diabled staticlly linking of fortran binaries
    - hard coded for now, ideally this would be a cmake option that can be set independently of architecture

## Build container

`make`

It gets tagged as `fs-src`

## Setup

```
mkdir ~/fs
cd ~/fs
mkdir bin
git clone git@github.com:pwighton/freesurfer.git
cd freesurfer
git checkout 20191115-ppc64
```

TODO: get the Freesurfer git annex data (this will compile and install, recon-all wont run without it.

## Jump into the container

```
docker run -it --rm -v ~/fs:/fs fs-src /bin/bash
```

Then build FreeSurfer.  Might have to tweak:
  - `-DGFORTRAN_LIBRARIES="/usr/lib/gcc/ppc64le-redhat-linux/4.8.2/libgfortran.so"`
  
```
cd /fs/freesurfer
rm -f ./CMakeCache.txt
cmake . \
  -DBUILD_GUIS=OFF \
  -DMINIMAL=ON \
  -DMAKE_BUILD_TYPE=Release \
  -DINSTALL_PYTHON_DEPENDENCIES=OFF \
  -DDISTRIBUTE_FSPYTHON=OFF \
  -DCMAKE_INSTALL_PREFIX="/fs/bin" \
  -DFS_PACKAGES_DIR="/usr" \
  -DPPC64=ON \
  -DCMAKE_CXX_FLAGS="-DPPC64" \
  -DCMAKE_C_FLAGS="-DPPC64" \
  -DGFORTRAN_LIBRARIES="/usr/lib/gcc/ppc64le-redhat-linux/4.8.2/libgfortran.so"
make -j 4
make install
```
