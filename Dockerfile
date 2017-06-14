# https://hub.docker.com/r/gmacario/build-yocto/
FROM gmacario/build-yocto

# Use bash as the default shell
SHELL ["bash", "-c"]

# Set default working directory
WORKDIR /usr/src/app

# Change working directory owner to build user
RUN sudo chown build.build /usr/src/app

# Get meta-openembedded layer
RUN git clone --depth 1 -b dizzy-next https://github.com/openembedded/meta-openembedded.git

# Clone the Yocto repository
RUN wget http://iotdk.intel.com/src/3.5/edison/iot-devkit-yp-poky-edison-20160606.zip && \
    unzip -qq iot-devkit-yp-poky-edison-20160606.zip

ENV POKY_PATH /usr/src/app/iot-devkit-yp-poky-edison-20160606/poky

# Copy meta-iot-cloud sources to working directory
COPY . /usr/src/app/meta-iot-cloud

# Create build directory
RUN source $POKY_PATH/oe-init-build-env build

# Change working directory to build directory
WORKDIR /usr/src/app/build

# Configure bblayers with meta-iot-cloud and meta-openembedded layers
RUN echo 'BBLAYERS += "/usr/src/app/meta-iot-cloud"' >> conf/bblayers.conf && \
    echo 'BBLAYERS += "/usr/src/app/meta-openembedded/meta-oe"' >> conf/bblayers.conf && \
    echo 'BBLAYERS += "/usr/src/app/meta-openembedded/meta-python"' >> conf/bblayers.conf

# Prevent git using git:// protocol to clone repos. use https:// instead
RUN git config --global url.https://github.com/.insteadOf git://github.com/

CMD bash
