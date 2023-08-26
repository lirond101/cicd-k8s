FROM debian

# Install kubectl
RUN apt-get update && apt-get install -y apt-transport-https gnupg curl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y kubectl