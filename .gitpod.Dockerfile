# docker build --no-cache --progress=plain -f .gitpod.Dockerfile .
FROM gitpod/workspace-full

# System
RUN bash -c "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3EFE0E0A2F2F60AA"
RUN bash -c "echo 'deb http://ppa.launchpad.net/tektoncd/cli/ubuntu jammy main'|sudo tee /etc/apt/sources.list.d/tektoncd-ubuntu-cli.list"
RUN bash -c "sudo install-packages direnv gettext mysql-client gnupg golang"
RUN bash -c "sudo apt-get update"
RUN bash -c "sudo pip install --upgrade pip"

# URL
RUN bash -c "git clone https://github.com/CaravanaCloud/up.git /workspace/up"
RUN bash -c "cd /workspace/up && ./install_all.sh"
RUN bash -c "up"

# OKD
# Installer from https://github.com/okd-project/okd/releases/download/4.14.0-0.okd-2023-12-01-225814/openshift-install-linux-4.14.0-0.okd-2023-12-01-225814.tar.gz
ARG REPO_URL="https://github.com/okd-project/okd/releases/download"
ARG RELEASE_TAG="4.14.0-0.okd-2023-12-01-225814"
ARG RELEASE_PKG="openshift-install-linux-4.14.0-0.okd-2023-12-01-225814.tar.gz"
ARG INSTALL_URL="${REPO_URL}/${RELEASE_TAG}/${RELEASE_PKG}"
ARG TEMP_DIR="/tmp/openshift-install"
ARG TEMP_FILE="openshift-install-linux.tar.gz"
RUN bash -c "mkdir -p '${TEMP_DIR}' \
    && wget -nv -O '${TEMP_DIR}/${TEMP_FILE}' '${INSTALL_URL}' \
    && tar zxvf '${TEMP_DIR}/${TEMP_FILE}' -C '${TEMP_DIR}' \
    && sudo mv  '${TEMP_DIR}/openshift-install' '/usr/local/bin/' \    
    && rm '${TEMP_DIR}/${TEMP_FILE}' \
    && openshift-install version \
    " 

# oc / kubectl
ARG RELEASE_PKG="openshift-client-linux-4.14.0-0.okd-2023-12-01-225814.tar.gz"
ARG INSTALL_URL="${REPO_URL}/${RELEASE_TAG}/${RELEASE_PKG}"
ARG TEMP_DIR="/tmp/openshift-client"
ARG TEMP_FILE="openshift-client-linux.tar.gz"
RUN bash -c "mkdir -p '${TEMP_DIR}' \
    && wget -nv -O '${TEMP_DIR}/${TEMP_FILE}' '${INSTALL_URL}' \
    && tar zxvf '${TEMP_DIR}/${TEMP_FILE}' -C '${TEMP_DIR}' \
    && sudo mv  '${TEMP_DIR}/oc' '/usr/local/bin/' \
    && sudo mv  '${TEMP_DIR}/kubectl' '/usr/local/bin/' \
    && rm '${TEMP_DIR}/${TEMP_FILE}' \
    && oc version --client \
    && kubectl version --client \
    "
# TODO    sudo bash -c 'oc completion bash > /etc/bash_completion.d/oc_bash_completion' \


# ccoctl
# https://github.com/okd-project/okd/releases/download/4.14.0-0.okd-2023-12-01-225814/ccoctl-linux-4.14.0-0.okd-2023-12-01-225814.tar.gz
ARG RELEASE_PKG="ccoctl-linux-4.14.0-0.okd-2023-12-01-225814.tar.gz"
ARG INSTALL_URL="${REPO_URL}/${RELEASE_TAG}/${RELEASE_PKG}"
ARG TEMP_DIR="/tmp/ccoctl"
ARG TEMP_FILE="ccoctl-linux.tar.gz"
RUN bash -c "mkdir -p '${TEMP_DIR}' \
    && wget -nv -O '${TEMP_DIR}/${TEMP_FILE}' '${INSTALL_URL}' \
    && tar zxvf '${TEMP_DIR}/${TEMP_FILE}' -C '${TEMP_DIR}' \
    && sudo mv  '${TEMP_DIR}/ccoctl' '/usr/local/bin/' \
    && rm '${TEMP_DIR}/${TEMP_FILE}' \
    && ccoctl help \
    "

# odo
ARG ODO_URL="https://developers.redhat.com/content-gateway/rest/mirror/pub/openshift-v4/clients/odo/v3.10.0/odo-linux-amd64"
RUN bash -c "curl -L ${ODO_URL} -o odo \
    && curl -L ${ODO_URL}.sha256 -o odo.sha256 \
    && echo "$(<odo.sha256)  odo" | shasum -a 256 --check \
    && sudo install -o root -g root -m 0755 odo /usr/local/bin/odo \
    "

# krew
# RUN bash -c "set -x; cd $(mktemp -d) \
#      && OS=$(uname | tr '[:upper:]' '[:lower:]') \
#      && ARCH=$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/') \
#      && KREW=krew-${OS}_${ARCH} \
#      && curl -fsSLO https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz \
#      && tar zxvf ${KREW}.tar.gz \
#      && ./${KREW} install krew \
#      && mkdir -p  /home/gitpod/bashrc.d/
#      && echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> /home/gitpod/bashrc.d/krew.sh \
#      && chmod +x /home/gitpod/bashrc.d/krew.sh
#      "

# Operator SDK
RUN bash -c "brew install operator-sdk"

# Helm, Terraform, Terragrunt
RUN bash -c "brew install helm terraform terragrunt"

# Java
ARG JAVA_SDK="17.0.7-amzn"
RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh \
    && sdk install java $JAVA_SDK \
    && sdk default java $JAVA_SDK \
    && sdk install quarkus"

# AWS CLIs
RUN bash -c "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip' && unzip awscliv2.zip \
    && sudo ./aws/install \
    && aws --version \
    "

RUN bash -c "npm install -g aws-cdk"

ARG SAM_URL="https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip"
RUN bash -c "curl -Ls '${SAM_URL}' -o '/tmp/aws-sam-cli-linux-x86_64.zip' \
    && unzip '/tmp/aws-sam-cli-linux-x86_64.zip' -d '/tmp/sam-installation' \
    && sudo '/tmp/sam-installation/install' \
    && sam --version"

RUN bash -c "pip install cloudformation-cli cloudformation-cli-java-plugin cloudformation-cli-go-plugin cloudformation-cli-python-plugin cloudformation-cli-typescript-plugin"

# Azure
RUN bash -c "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash"

# Aliyun
RUN bash -c "brew install aliyun-cli"

# ArgoCD and Tekton
RUN bash -c "brew install argocd"
RUN bash -c "sudo apt install -y tektoncd-cli \
    && tkn version"

# Kustomize
RUN bash -c "curl -s 'https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh'  | bash"

# Done :)
RUN bash -c "echo 'done.'"
