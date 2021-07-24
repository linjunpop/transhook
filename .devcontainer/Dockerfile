FROM ubuntu as dev

RUN apt-get update -qq && \
  apt-get install -qq -y \
  curl \
  git \
  dirmngr \
  gpg \
  gawk \
  unzip \
  build-essential \
  autoconf \
  libssl-dev \
  libncurses5-dev \
  m4 \
  libssh-dev \
  inotify-tools

RUN useradd -ms $(which bash) asdf

USER asdf

RUN git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.8.1 && \
  echo '. $HOME/.asdf/asdf.sh' >> $HOME/.bashrc && \
  echo '. $HOME/.asdf/asdf.sh' >> $HOME/.profile

ENV PATH /home/asdf/.asdf/bin:/home/asdf/.asdf/shims:$PATH

RUN /bin/bash -c "\
  asdf plugin-add elixir && \
  asdf plugin-add erlang && \
  asdf plugin-add nodejs \
  "

WORKDIR /app

COPY .tool-versions /app

RUN /bin/bash -c "asdf install"

ENV LANG C.UTF-8

WORKDIR /workspace
