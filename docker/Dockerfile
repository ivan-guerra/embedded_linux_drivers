# Create a docker image that when run will build the Linux kernel and our
# custom modules. See scripts/build.sh for an example of how to build/run this
# image.

FROM debian:10.8-slim

RUN apt-get update     &&       \
    apt-get install -y          \
        bc                      \
        bison                   \
        build-essential         \
        ccache                  \
        cpio                    \
        curl                    \
        flex                    \
        gcc-arm-linux-gnueabihf \
        libelf-dev              \
        libncurses-dev          \
        libssl-dev              \
        lzop                    \
        u-boot-tools            \
        vim-tiny

# Use ccache (make it appear in path earlier than /usr/bin/gcc, etc.).
RUN for p in gcc g++ cc c++; do ln -vs /usr/bin/ccache /usr/local/bin/$p; done

# It's required that when calling docker build, all the info needed to create
# a clone of the host user is provided. This simplifies things like re-using
# object files between docker runs to speed up builds and setting the host
# user as the owner of all build artefacts.
ARG USER
ARG HOME
ARG USER_ID
ARG GROUP_ID

# Add the host user group and user account.
RUN groupadd -g ${GROUP_ID} $USER &&\
    useradd -l -u ${USER_ID} -g $USER $USER &&\
    install -d -m 0755 -o $USER -g $USER $HOME

# Install the kernel build script in the user's home directory.
COPY kbuild.sh $HOME
RUN chown $USER:$USER $HOME/kbuild.sh &&\
    chmod +x $HOME/kbuild.sh

USER $USER
WORKDIR $HOME

CMD ["/bin/bash", "-c", "./kbuild.sh"]
