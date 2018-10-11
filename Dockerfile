FROM jenkins/jenkins:2.73.3
MAINTAINER Truc C. Dao <truc.c.dao@gmail.com>

# Suppress apt installation warnings
ENV DEBIAN_FRONTEND=noninteractive

# Change to root user
USER root

# Used to set the docker group ID
# Set to 497 by default, which is the group ID used by AWS Linux ECS Instance
ARG DOCKER_GID=497

# Create Docker Group with GID
# Set default value of 497 if DOCKER_GID set to blank string by Docker Compose
RUN groupadd -g ${DOCKER_GID:-497} docker

# Install base packages
RUN apt-get update -y && \
    apt-get install apt-transport-https ca-certificates curl software-properties-common python-dev python-setuptools gcc make libssl-dev libffi-dev -y && \
    easy_install pip

# Install Docker Engine
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" | tee /etc/apt/sources.list.d/docker.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 437D05B5 && \
    apt-get update -y && \
    apt-get remove docker docker-engine docker.io -y && \
    apt-get install docker-ce -y && \
    usermod -aG docker jenkins && \
    usermod -aG users jenkins

# Install Docker Compose
RUN pip install docker-compose boto boto3

# Change to jenkins user
USER jenkins

# Add Jenkins plugins
# COPY plugins.txt /usr/share/jenkins/plugins.txt
# RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
