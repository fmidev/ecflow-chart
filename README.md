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

### ssl

Create necessary certificates with these [instructions](https://ecflow.readthedocs.io/en/latest/ug/user_manual/ecflow_server/security/open_ssl.html).

```
oc create secret generic ecf-ssl --from-file=dh2048.pem=ssl/dh2048.pem --from-file=server.key=ssl/server.key --from-file=server.crt=ssl/server.crt
```

## api

REST api uses token-based authentication. The list containing accepted tokens is mounted to container from a configmap. The name of the map is given with api.tokens.configMapName.

Format of the file is given here: https://ecflow.readthedocs.io/en/latest/rest_api.html#token-based-authentication

## sidecar

sidecar will try to pull suites and scripts from a git repo when
* non-persistent storage is used
* persistent storage is used and container starts for the first time

If git repo is private, an [access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) secret needs to be created
```
oc create secret generic git-read-token --from-literal=token=github.token
```

# Usage:

helm install ecflow . -f values.yaml
