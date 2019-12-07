FROM amd64/centos:8

LABEL maintainer="snowdream <sn0wdr1am@icloud.com>"

COPY .vimrc /root/

RUN dnf -y update \
    && dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && dnf clean all