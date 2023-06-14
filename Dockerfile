FROM gradescope/auto-builds:ubuntu-20.04
LABEL maintainer="emenendez6@gatech.edu"

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

COPY ./bin /opt/bin
ENV PATH="${PATH}:/opt/bin"

RUN apt-get update && apt-get install --no-install-recommends -y \
    bzip2 \
    clang \
    clang-tools \
    gcc-multilib \
    gdb \
    imagemagick \
    libcurl4-openssl-dev \
    libgmp-dev \
    libmagickcore-dev \
    libssl-dev \
    libtool \
    llvm \
    net-tools \
    netcat \
    pkg-config \
    portmap \
    python3 \
    python3-dev \
    python3-pip \
    tcpdump \
    rpcbind \
    valgrind

RUN python3 -m pip install --upgrade pip

RUN python3 -m pip install --upgrade \
    future \
    cryptography \
    pyopenssl \
    ndg-httpsclient \
    pyasn1

CMD ["/bin/bash"]
