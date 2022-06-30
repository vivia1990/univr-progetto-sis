FROM ubuntu:18.04
ARG pandoc_version=2.18

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG ROOT_PW='docker'

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM="xterm-256color"

RUN apt -y update && apt -y upgrade
RUN dpkg --add-architecture i386
RUN apt -y update
RUN apt -y install build-essential gcc-multilib git nano vim neofetch htop wget librsvg2-bin
RUN apt-get -y install apt-utils sudo tzdata curl
RUN apt-get -y install texlive texlive-science texlive-xetex texlive-lang-italian texlive-latex-extra python3 python3-pip

RUN echo "root:$ROOT_PW" | chpasswd

RUN addgroup --gid $GROUP_ID www
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID www

RUN echo "www:www" | chpasswd

WORKDIR /tmp
RUN wget https://github.com/jgm/pandoc/releases/download/${pandoc_version}/pandoc-${pandoc_version}-1-amd64.deb && dpkg -i pandoc-${pandoc_version}-1-amd64.deb
RUN sudo pip3 install pandoc-eqnos pandoc-fignos pandoc-tablenos
RUN wget https://github.com/JackHack96/logic-synthesis/releases/download/1.3.6/sis_1.3.6-1_amd64.deb
RUN dpkg -i sis_1.3.6-1_amd64.deb

VOLUME [ "/data" ]

WORKDIR  /data
# start as non root user to avoid permissions conflict with the files created inside the container
USER www