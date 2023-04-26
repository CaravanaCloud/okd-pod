# docker build --no-cache --progress=plain -f .gitpod.Dockerfile .
FROM gitpod/workspace-full

# System
RUN bash -c "sudo apt-get update"
RUN bash -c "sudo install-packages direnv gettext mysql-client"

# Java
ARG JAVA_SDK="20-amzn"
RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh && sdk install java $JAVA_SDK && sdk default java $JAVA_SDK && sdk install quarkus"

# AWS
RUN bash -c "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip' && unzip awscliv2.zip && sudo ./aws/install"
RUN bash -c "npm install -g aws-cdk"
RUN bash -c "curl -Ls 'https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip' -o '/tmp/aws-sam-cli-linux-x86_64.zip' && unzip '/tmp/aws-sam-cli-linux-x86_64.zip' -d '/tmp/sam-installation' && sudo '/tmp/sam-installation/install' && sam --version"
RUN bash -c "pip install cloudformation-cli cloudformation-cli-java-plugin cloudformation-cli-go-plugin cloudformation-cli-python-plugin cloudformation-cli-typescript-plugin"

# Aliyun
ARG URL_ALIYUN="https://aliyuncli.alicdn.com/aliyun-cli-linux-3.0.2-amd64.tgz?spm=a2c63.p38356.0.0.51f94891CK6zc9&file=aliyun-cli-linux-3.0.2-amd64.tgz"
RUN bash -c "curl '$URL_ALIYUN' -o 'aliyun-cli-linux-3.0.2-amd64.tgz' && tar zxvf aliyun-cli-linux-3.0.2-amd64.tgz && sudo mv aliyun /usr/local/bin/aliyun && rm aliyun-cli-linux-3.0.2-amd64.tgz"

# Azure
RUN bash -c "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash"

# Red Hat
# RUN bash -c "mkdir -p '/tmp/openshift-installer' && wget -nv -O '/tmp/openshift-installer/openshift-install-linux.tar.gz' 'https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/openshift-install-linux.tar.gz' && tar zxvf '/tmp/openshift-installer/openshift-install-linux.tar.gz' -C '/tmp/openshift-installer' && sudo mv  '/tmp/openshift-installer/openshift-install' '/usr/local/bin/' && rm '/tmp/openshift-installer/openshift-install-linux.tar.gz'"
ARG URL_INSTALLER="https://github.com/okd-project/okd/releases/download/4.12.0-0.okd-2023-04-16-041331/openshift-install-linux-4.12.0-0.okd-2023-04-16-041331.tar.gz"
RUN bash -c "mkdir -p '/tmp/openshift-installer' && wget -nv -O '/tmp/openshift-installer/openshift-install-linux.tar.gz' '${URL_INSTALLER}' && tar zxvf '/tmp/openshift-installer/openshift-install-linux.tar.gz' -C '/tmp/openshift-installer' && sudo mv  '/tmp/openshift-installer/openshift-install' '/usr/local/bin/' && rm '/tmp/openshift-installer/openshift-install-linux.tar.gz'"
ARG URL_CLIENTS="https://github.com/okd-project/okd/releases/download/4.12.0-0.okd-2023-04-16-041331/openshift-client-linux-4.12.0-0.okd-2023-04-16-041331.tar.gz"
RUN bash -c "mkdir -p '/tmp/oc' && wget -nv -O '/tmp/oc/openshift-client-linux.tar.gz' '${URL_CLIENTS}' && tar zxvf '/tmp/oc/openshift-client-linux.tar.gz' -C '/tmp/oc' && sudo mv '/tmp/oc/oc' '/usr/local/bin/' && sudo mv '/tmp/oc/kubectl' '/usr/local/bin/' && rm '/tmp/oc/openshift-client-linux.tar.gz'"
ARG URL_CCOCTL="https://github.com/okd-project/okd/releases/download/4.12.0-0.okd-2023-04-16-041331/ccoctl-linux-4.12.0-0.okd-2023-04-16-041331.tar.gz"
RUN bash -c "mkdir -p '/tmp/ccoctl' && wget -nv -O '/tmp/ccoctl/ccoctl-linux.tar.gz' '${URL_CCOCTL}' && tar zxvf '/tmp/ccoctl/ccoctl-linux.tar.gz' -C '/tmp/ccoctl' && sudo mv '/tmp/ccoctl/ccoctl' '/usr/local/bin/' && rm '/tmp/ccoctl/ccoctl-linux.tar.gz'"

