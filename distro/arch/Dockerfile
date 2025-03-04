FROM archlinux:latest
LABEL authors="sbuglione"

COPY ./config /tmp/config

RUN /tmp/config/docker/packages.sh
RUN /tmp/config/docker/config-wsl.sh

# Clean UP
RUN rm -rf /tmp/config

CMD ["ls", "/"]