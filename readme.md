# Readme

Compile FreeSurfer on ppc64.  

Using the docker container in this repo, which compiles itk 4.13 from source
 and mostly following along here:
  - https://github.com/corticometrics/fs-docker

## Build container

`make`

It gets tagged as `fs-src`

## Setup

mkdir ~/fs
cd ~/fs
mkdir bin
git clone https://github.com/freesurfer/freesurfer.git
cd freesurfer
git checkout dev

TODO: get the Freesurfer git annex data (this will compile and install, recon-all wont run without it.

## Jump into the container

```
docker run -it --rm -v ~/fs:/fs fs-src /bin/bash
```

Then build FreeSurfer.  Might have to tweak:
  - `-DGFORTRAN_LIBRARIES="/usr/lib/gcc/x86_64-redhat-linux/4.8.2/libgfortran.so"`

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
  -DGFORTRAN_LIBRARIES="/usr/lib/gcc/x86_64-redhat-linux/4.8.2/libgfortran.so"
make -j 4
make install
```
