# ecflow-chart

Helm chart for ecFlow 
* source: https://github.com/ecmwf/ecflow.git
* containerized with: https://github.com/fmidev/ecflow-s2i.git.

# Contents

Chart contains configuration for multiple pods:

* ecflow-server
  * currently hard-coded to service type ClusterIP, meaning that access to server with UI is only possible with oc port-forward
  * can use persistent or non-persistent disk
  * can be initialized from a git repo containing ecFlow suites and scripts
  * contains a sidecar container
* log server
  * can be enabled byt setting logserver.enabled: true
  * similarly access is only possible with oc port-forward
* api
  * can be enabled by setting api.enabled: true
  * supports token-based authentication
* sidecar
  * container than can be used to access the running ecFlow instance and load new suites etc
  * if storage.persistent: true, sidecar will automatically try to pull latest changes from initialization git repo (test/prod mode). It does not reload suites automatically.
  * if storage.persistent: false, sidecar will sleep indefinitely

A new serviceaccount is created that has access to kube resources like pods, templates and jobs.

# Preconditions

Necessary passwords and accounts need to be created.

## api

REST api uses token-based authentication. The list containing accepted tokens is mounted to container from a configmap. The name of the map is given with api.tokens.configMapName.

Format of the file is given here: https://ecflow.readthedocs.io/en/latest/rest_api.html#token-based-authentication

## sidecar

sidecar will try to pull suites and scripts from a git repo when
* non-persistent storage is used
* persistent storage is used and container starts for the first time

If git repo is private, an ssh private key is needed. The name of the key should be put to server.suites.repos.sshKey.

# Usage:

helm install ecflow . -f values.yaml
