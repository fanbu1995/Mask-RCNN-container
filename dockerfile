FROM continuumio/anaconda3
MAINTAINER Fan Bu <fan.bu1@duke.edu>

ARG DEBIAN_FRONTEND=noninteractive

# Essentials: developer tools, build tools, OpenBLAS
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils git curl vim unzip openssh-client wget \
    build-essential cmake \
    libopenblas-dev

#
# Python 3.5
#
# For convenience, alias (but don't sym-link) python & pip to python3 & pip3 as recommended in:
# http://askubuntu.com/questions/351318/changing-symlink-python-to-python3-causes-problems
RUN pip install --no-cache-dir --upgrade pip setuptools && \
    echo "alias python='python3'" >> /root/.bash_aliases && \
    echo "alias pip='pip3'" >> /root/.bash_aliases

# Pillow and it's dependencies
RUN apt-get install -y --no-install-recommends libjpeg-dev zlib1g-dev && \
    pip3 --no-cache-dir install Pillow
# Science libraries and other common packages
RUN pip3 --no-cache-dir install \
    numpy scipy sklearn scikit-image pandas matplotlib Cython requests

#
# Tensorflow 1.13.1 - CPU
# --> try 1.5.0 instead, to accommodate old CPUs that do not support AVX
RUN pip3 install --no-cache-dir --upgrade tensorflow==1.13.1

# Keras 2.1.5
#
RUN pip3 install --no-cache-dir --upgrade h5py pydot_ng keras==2.1.5 

# Try installing openCV in an easy way
RUN pip3 --no-cache-dir install opencv-python opencv-contrib-python


# A bunch of other stuff
RUN pip3 --no-cache-dir install \
    imgaug ipython[all]

#
# PyCocoTools
#
# Using a fork of the original that has a fix for Python 3.
# I submitted a PR to the original repo (https://github.com/cocodataset/cocoapi/pull/50)
# but it doesn't seem to be active anymore.
RUN pip3 install --no-cache-dir git+https://github.com/waleedka/coco.git#subdirectory=PythonAPI

# Copying "Mask_RCNN" directory into this container
# COPY ./Mask_RCNN/ /root/Mask_RCNN/

# Set up Mask_RCNN
# RUN cd /root/Mask_RCNN && \
#     wget https://github.com/matterport/Mask_RCNN/releases/download/v2.0/mask_rcnn_coco.h5 && \
#     python3 setup.py install


WORKDIR "/root"
CMD ["/bin/bash"]
