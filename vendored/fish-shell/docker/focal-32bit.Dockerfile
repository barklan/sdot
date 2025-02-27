FROM ubuntu:20.04
LABEL org.opencontainers.image.source=https://github.com/fish-shell/fish-shell

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV CFLAGS="-m32"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get -y install \
    build-essential \
    cmake \
    g++-multilib \
    gettext \
    git \
    locales \
    ninja-build \
    pkg-config \
    python3 \
    python3-pexpect \
    sudo \
    tmux \
  && locale-gen en_US.UTF-8 \
  && apt-get clean

RUN groupadd -g 1000 fishuser \
  && useradd -p $(openssl passwd -1 fish) -d /home/fishuser -m -u 1000 -g 1000 fishuser \
  && adduser fishuser sudo \
  && mkdir -p /home/fishuser/fish-build \
  && mkdir /fish-source \
  && chown -R fishuser:fishuser /home/fishuser /fish-source

USER fishuser
WORKDIR /home/fishuser

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh \
  && sh /tmp/rustup.sh -y --default-toolchain nightly --component rust-src

COPY fish_run_tests.sh /

CMD . ~/.cargo/env \
    && rustup target add i686-unknown-linux-gnu \
    && /fish_run_tests.sh -DFISH_USE_SYSTEM_PCRE2=OFF -DRust_CARGO_TARGET=i686-unknown-linux-gnu
