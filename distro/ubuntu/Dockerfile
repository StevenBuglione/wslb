FROM ubuntu:latest
LABEL authors="sbuglione"

RUN userdel -r ubuntu

# Force all users to use bash as the default shell.
RUN sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd

COPY ./config /tmp/config

RUN /tmp/config/docker/packages.sh
RUN /tmp/config/docker/config-wsl.sh


# Clean UP
RUN rm -rf /tmp/config


CMD ["ls", "/"]