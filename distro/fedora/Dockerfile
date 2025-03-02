FROM fedora:latest
LABEL authors="sbuglione"

COPY ./config /tmp/config

RUN /tmp/config/docker/packages.sh
RUN /tmp/config/docker/config-wsl.sh
RUN /tmp/config/docker/install-nix.sh

RUN rm -rf /tmp/config

CMD ["ls", "/"]