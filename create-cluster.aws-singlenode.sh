#!/bin/bash
set -ex

check_variables() {
  for var in "$@"; do
    if [ -z "${!var}" ]; then
      echo "Error: Variable '$var' is not set or has zero length." >&2
      exit 1
    fi
  done
}

export AWS_REGION=${AWS_REGION:-"us-west-2"}
export CLUSTER_NAME="okd-pod-$RANDOM"
export OCP_BASE_DOMAIN=${OCP_BASE_DOMAIN:-"devcluster.openshift.com"}
export SSH_KEY=$(cat $HOME/.ssh/id_rsa.pub)
check_variables "AWS_REGION" "OCP_BASE_DOMAIN" "PULL_SECRET" "SSH_KEY"

aws sts get-caller-identity
envsubst < "install-config.aws-singlenode.env.yaml" > "install-config.yaml"
cp "install-config.yaml" "install-config.bak.yaml"

echo "WARNING: This will run 1 x m6i.xlarge	instances on your AWS account."
sleep 5

openshift-install create cluster
openshift-install wait-for install-complete
export KUBECONFIG=/workspace/okd-pod/auth/kubeconfig

oc cluster-info

# some things to try
# kubectl get nodes
# kubectl get deployments --all-namespaces
# kubectl run -it --rm --restart=Never --image=busybox:1.33.1 testpod -- /bin/sh


echo "cluster created."
