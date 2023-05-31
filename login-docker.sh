#!/bin/bash

oc new-project "okd-project"

oc create secret docker-registry dockersecret \
    --docker-server="docker.io" \
    --docker-username="$DOCKER_USERNAME" \
    --docker-password="$DOCKER_PASSWORD" \
    --docker-email="$DOCKER_EMAIL"

oc secrets link default dockersecret --for=pull --namespace="okd-project"
