# operator-sdk olm install
kubectl krew install operator
kubectl operator install cert-manager -n operators --channel stable --approval Automatic
