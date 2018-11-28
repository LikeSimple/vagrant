#! /bin/bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./tls.key -out ./tls.crt -subj "/CN=kubernetes-dashboard.xyz"
kubectl create secret tls kubernetes-dashboard-tls --key ./tls.key --cert ./tls.crt -n kube-system