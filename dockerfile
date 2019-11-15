FROM centos:7

RUN yum -y update

# https://github.com/corticometrics/fs6-cloud/blob/10ff107483885e368d3733e67b6a5017d53ed4b7/docker/dockerfile--fs6-base#L3
# https://github.com/corticometrics/fs6-cloud/blob/10ff107483885e368d3733e67b6a5017d53ed4b7/docker/dockerfile--fs6-payload#L4
# https://surfer.nmr.mgh.harvard.edu/fswiki/BuildRequirements
RUN yum -y install \
  cmake \
  binutils \
  libGLU \
  libXmu \
  sudo \
  nano \
  find \
  which \
  unzip \
  wget \
  curl \
  tar \
  tcsh \
  bc \
  libgomp \
  net-tools \
  psmisc \
  perl \
  zlib-devel \
  openssl \
  openssl-devel \
  libcurl-devel \
  vim-common \
  libX11-devel \
  opencv \
  opencv-devel \
  opencv-python \
  libXmu-devel \
  mesa-libGL-devel \
  lapack-devel \
  blas-devel \
  lapack-static \
  blas-static
RUN yum -y group install "Development Tools"

# Build cmake 3.12.3
# ---------------------------------------------------------------------
# https://github.com/corticometrics/fs-docker/blob/2cd843bf1a274eb735b8b2cb52057c9fcf23645c/build/Dockerfile#L44
RUN curl -sSL --retry 5 https://cmake.org/files/v3.12/cmake-3.12.3.tar.gz | tar -xz && \
    cd cmake-3.12.3 && ./configure && make -j 8 && make install && cd - && rm -rf cmake-3.12.3

# Build itk 4.13.2
# ---------------------------------------------------------------------
# https://github.com/freesurfer/freesurfer/blob/dev/packages/source/build_itk.sh
# but removing (x86 specific):
#  -DCMAKE_CXX_FLAGS="-msse2 -mfpmath=sse"
#  -DCMAKE_C_FLAGS="-msse2 -mfpmath=sse"
RUN curl -sSL --retry 5 https://sourceforge.net/projects/itk/files/itk/4.13/InsightToolkit-4.13.2.tar.gz/download | tar -xz && \
  cd InsightToolkit-4.13.2 && mkdir -p build && cd build && \
  cmake .. \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_BUILD_TYPE=Release \
    -DITK_BUILD_DEFAULT_MODULES=OFF \
    -DITKGroup_Core=ON \
    -DITKGroup_Filtering=ON \
    -DITKGroup_Segmentation=ON \
    -DITKGroup_IO=ON \
    -DModule_AnisotropicDiffusionLBR=ON \
    -DBUILD_TESTING=OFF && \
  make -j 8 && make install

# Install Python 3.6, update pip and wheel
# ---------------------------------------------------------------------
# https://github.com/corticometrics/fs-docker/blob/2cd843bf1a274eb735b8b2cb52057c9fcf23645c/build/Dockerfile#L49
RUN cd /
RUN curl -sSL --retry 5 https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tgz | tar -xz && \
    cd Python-3.6.5 && ./configure && make -j 8 && make install && cd - && \
    rm -rf Python-3.6.5 Python-3.6.5.tgz 
RUN pip3 install -q --no-cache-dir -U pip && \
    pip3 install -q --no-cache-dir wheel && \
    sync 

#RUN yum clean all

VOLUME /fs
WORKDIR /fs
