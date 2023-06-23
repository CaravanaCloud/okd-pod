# Install certmanager / openshift routes
# 
# 
oc apply -f https://github.com/jetstack/cert-manager/releases/download/v1.8.0/cert-manager.yaml
oc apply -f https://github.com/cert-manager/openshift-routes/releases/latest/download/cert-manager-openshift-routes.yaml


export NS="cert-manager"
export EMAIL=$GITPOD_GIT_USER_EMAIL

envsubst < "certmanager-issuer.env.k8s.yaml" > ".certmanager-issuer.k8s.yaml"
oc apply -f ".certmanager-issuer.k8s.yaml"