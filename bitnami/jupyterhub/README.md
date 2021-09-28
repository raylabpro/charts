# JupyterHub

[JupyterHub](https://github.com/jupyterhub/jupyterhub) is a multi-user version of the notebook designed for companies, classrooms and research labs.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/jupyterhub
```

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [JupyterHub](https://github.com/jupyterhub/jupyterhub) Deployment in a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

[Learn more about the default configuration of the chart](https://docs.bitnami.com/kubernetes/infrastructure/jupyterhub/get-started/understand-default-configuration/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/jupyterhub
```

These commands deploy JupyterHub on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` helm release:

```console
$ helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                | Description                                                                         | Value |
| ------------------- | ----------------------------------------------------------------------------------- | ----- |
| `kubeVersion`       | Override Kubernetes version                                                         | `""`  |
| `nameOverride`      | String to partially override common.names.fullname (will maintain the release name) | `""`  |
| `fullnameOverride`  | String to fully override common.names.fullname                                      | `""`  |
| `commonLabels`      | Labels to add to all deployed objects                                               | `{}`  |
| `commonAnnotations` | Annotations to add to all deployed objects                                          | `{}`  |
| `extraDeploy`       | Array of extra objects to deploy with the release                                   | `[]`  |


### Hub deployment parameters

| Name                                        | Description                                                                               | Value                 |
| ------------------------------------------- | ----------------------------------------------------------------------------------------- | --------------------- |
| `hub.image.registry`                        | Hub image registry                                                                        | `docker.io`           |
| `hub.image.repository`                      | Hub image repository                                                                      | `bitnami/jupyterhub`  |
| `hub.image.tag`                             | Hub image tag (immutabe tags are recommended)                                             | `1.4.2-debian-10-r65` |
| `hub.image.pullPolicy`                      | Hub image pull policy                                                                     | `IfNotPresent`        |
| `hub.image.pullSecrets`                     | Hub image pull secrets                                                                    | `[]`                  |
| `hub.startupProbe.enabled`                  | Enable startupProbe                                                                       | `true`                |
| `hub.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                    | `10`                  |
| `hub.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                           | `10`                  |
| `hub.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                          | `3`                   |
| `hub.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                        | `30`                  |
| `hub.startupProbe.successThreshold`         | Success threshold for startupProbe                                                        | `1`                   |
| `hub.livenessProbe.enabled`                 | Enable livenessProbe                                                                      | `true`                |
| `hub.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                   | `10`                  |
| `hub.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                          | `10`                  |
| `hub.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                         | `3`                   |
| `hub.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                       | `30`                  |
| `hub.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                       | `1`                   |
| `hub.readinessProbe.enabled`                | Enable readinessProbe                                                                     | `true`                |
| `hub.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                  | `10`                  |
| `hub.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                         | `10`                  |
| `hub.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                        | `3`                   |
| `hub.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                      | `30`                  |
| `hub.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                      | `1`                   |
| `hub.baseUrl`                               | Hub base URL                                                                              | `/`                   |
| `hub.adminUser`                             | Hub Dummy authenticator admin user                                                        | `user`                |
| `hub.password`                              | Hub Dummy authenticator password                                                          | `""`                  |
| `hub.configuration`                         | Hub configuration file (to be used by jupyterhub_config.py)                               | `""`                  |
| `hub.containerPort`                         | Hub container port                                                                        | `8081`                |
| `hub.existingConfigmap`                     | Configmap with Hub init scripts (replaces the scripts in templates/hub/configmap.yml)     | `""`                  |
| `hub.existingSecret`                        | Secret with hub configuration (replaces the hub.configuration value) and proxy token      | `""`                  |
| `hub.command`                               | Override Hub default command                                                              | `[]`                  |
| `hub.args`                                  | Override Hub default args                                                                 | `[]`                  |
| `hub.pdb.create`                            | Deploy Hub PodDisruptionBudget                                                            | `false`               |
| `hub.pdb.minAvailable`                      | Set minimum available hub instances                                                       | `""`                  |
| `hub.pdb.maxUnavailable`                    | Set maximum available hub instances                                                       | `""`                  |
| `hub.priorityClassName`                     | Hub pod priority class name                                                               | `""`                  |
| `hub.hostAliases`                           | Add deployment host aliases                                                               | `[]`                  |
| `hub.resources.limits`                      | The resources limits for the container                                                    | `{}`                  |
| `hub.resources.requests`                    | The requested resources for the container                                                 | `{}`                  |
| `hub.containerSecurityContext.enabled`      | Enabled Hub containers' Security Context                                                  | `true`                |
| `hub.containerSecurityContext.runAsUser`    | Set Hub container's Security Context runAsUser                                            | `1000`                |
| `hub.containerSecurityContext.runAsNonRoot` | Set Hub container's Security Context runAsNonRoot                                         | `true`                |
| `hub.podSecurityContext.enabled`            | Enabled Hub pods' Security Context                                                        | `true`                |
| `hub.podSecurityContext.fsGroup`            | Set Hub pod's Security Context fsGroup                                                    | `1001`                |
| `hub.podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                  |
| `hub.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                |
| `hub.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                  |
| `hub.nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set                                     | `""`                  |
| `hub.nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set                                  | `[]`                  |
| `hub.affinity`                              | Affinity for pod assignment.                                                              | `{}`                  |
| `hub.nodeSelector`                          | Node labels for pod assignment.                                                           | `{}`                  |
| `hub.tolerations`                           | Tolerations for pod assignment.                                                           | `[]`                  |
| `hub.podLabels`                             | Pod extra labels                                                                          | `{}`                  |
| `hub.podAnnotations`                        | Annotations for server pods.                                                              | `{}`                  |
| `hub.lifecycleHooks`                        | LifecycleHooks for the hub container to automate configuration before or after startup    | `{}`                  |
| `hub.customStartupProbe`                    | Override default startup probe                                                            | `{}`                  |
| `hub.customLivenessProbe`                   | Override default liveness probe                                                           | `{}`                  |
| `hub.customReadinessProbe`                  | Override default readiness probe                                                          | `{}`                  |
| `hub.updateStrategy.type`                   | Update strategy - only really applicable for deployments with RWO PVs attached            | `RollingUpdate`       |
| `hub.extraEnvVars`                          | Add extra environment variables to the Hub container                                      | `[]`                  |
| `hub.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars                                      | `""`                  |
| `hub.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars                                         | `""`                  |
| `hub.extraVolumes`                          | Optionally specify extra list of additional volumes for Hub pods                          | `[]`                  |
| `hub.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for Hub container(s)             | `[]`                  |
| `hub.initContainers`                        | Add additional init containers to the Hub pods                                            | `[]`                  |
| `hub.sidecars`                              | Add additional sidecar containers to the Hub pod                                          | `[]`                  |


### Hub RBAC parameters

| Name                        | Description                                          | Value  |
| --------------------------- | ---------------------------------------------------- | ------ |
| `hub.serviceAccount.create` | Specifies whether a ServiceAccount should be created | `true` |
| `hub.serviceAccount.name`   | Override Hub service account name                    | `""`   |
| `hub.rbac.create`           | Specifies whether RBAC resources should be created   | `true` |


### Hub Traffic Exposure Parameters

| Name                                      | Description                                              | Value       |
| ----------------------------------------- | -------------------------------------------------------- | ----------- |
| `hub.networkPolicy.enabled`               | Deploy Hub network policies                              | `true`      |
| `hub.networkPolicy.allowInterspaceAccess` | Allow communication between pods in different namespaces | `true`      |
| `hub.networkPolicy.extraIngress`          | Add extra ingress rules to the NetworkPolicy             | `""`        |
| `hub.networkPolicy.extraEgress`           | Add extra ingress rules to the NetworkPolicy             | `""`        |
| `hub.service.type`                        | Hub service type                                         | `ClusterIP` |
| `hub.service.port`                        | Hub service HTTP port                                    | `8081`      |
| `hub.service.loadBalancerIP`              | Hub service LoadBalancer IP (optional, cloud specific)   | `""`        |
| `hub.service.loadBalancerSourceRanges`    | loadBalancerIP source ranges for the Service             | `[]`        |
| `hub.service.nodePorts.http`              | NodePort for the HTTP endpoint                           | `""`        |
| `hub.service.externalTrafficPolicy`       | External traffic policy for the service                  | `Cluster`   |


### Proxy deployment parameters

| Name                                          | Description                                                                               | Value                             |
| --------------------------------------------- | ----------------------------------------------------------------------------------------- | --------------------------------- |
| `proxy.image.registry`                        | Proxy image registry                                                                      | `docker.io`                       |
| `proxy.image.repository`                      | Proxy image repository                                                                    | `bitnami/configurable-http-proxy` |
| `proxy.image.tag`                             | Proxy image tag (immutable tags are recommended)                                          | `4.5.0-debian-10-r65`             |
| `proxy.image.pullPolicy`                      | Proxy image pull policy                                                                   | `IfNotPresent`                    |
| `proxy.image.pullSecrets`                     | Proxy image pull secrets                                                                  | `[]`                              |
| `proxy.image.debug`                           | Activate verbose output                                                                   | `false`                           |
| `proxy.startupProbe.enabled`                  | Enable startupProbe                                                                       | `true`                            |
| `proxy.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                    | `10`                              |
| `proxy.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                           | `10`                              |
| `proxy.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                          | `3`                               |
| `proxy.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                        | `30`                              |
| `proxy.startupProbe.successThreshold`         | Success threshold for startupProbe                                                        | `1`                               |
| `proxy.livenessProbe.enabled`                 | Enable livenessProbe                                                                      | `true`                            |
| `proxy.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                   | `10`                              |
| `proxy.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                          | `10`                              |
| `proxy.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                         | `3`                               |
| `proxy.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                       | `30`                              |
| `proxy.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                       | `1`                               |
| `proxy.readinessProbe.enabled`                | Enable readinessProbe                                                                     | `true`                            |
| `proxy.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                  | `10`                              |
| `proxy.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                         | `10`                              |
| `proxy.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                        | `3`                               |
| `proxy.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                      | `30`                              |
| `proxy.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                      | `1`                               |
| `proxy.command`                               | Override Proxy default command                                                            | `[]`                              |
| `proxy.args`                                  | Override Proxy default args                                                               | `[]`                              |
| `proxy.secretToken`                           | Proxy secret token (used for communication with the Hub)                                  | `""`                              |
| `proxy.hostAliases`                           | Add deployment host aliases                                                               | `[]`                              |
| `proxy.pdb.create`                            | Deploy Proxy PodDisruptionBudget                                                          | `false`                           |
| `proxy.pdb.minAvailable`                      | Set minimum available proxy instances                                                     | `""`                              |
| `proxy.pdb.maxUnavailable`                    | Set maximum available proxy instances                                                     | `""`                              |
| `proxy.containerPort.api`                     | Proxy api container port                                                                  | `8001`                            |
| `proxy.containerPort.http`                    | Proxy http container port                                                                 | `8000`                            |
| `proxy.priorityClassName`                     | Proxy pod priority class name                                                             | `""`                              |
| `proxy.resources.limits`                      | The resources limits for the container                                                    | `{}`                              |
| `proxy.resources.requests`                    | The requested resources for the container                                                 | `{}`                              |
| `proxy.containerSecurityContext.enabled`      | Enabled Proxy containers' Security Context                                                | `true`                            |
| `proxy.containerSecurityContext.runAsUser`    | Set Proxy container's Security Context runAsUser                                          | `1001`                            |
| `proxy.containerSecurityContext.runAsNonRoot` | Set Proxy container's Security Context runAsNonRoot                                       | `true`                            |
| `proxy.podSecurityContext.enabled`            | Enabled Proxy pods' Security Context                                                      | `true`                            |
| `proxy.podSecurityContext.fsGroup`            | Set Proxy pod's Security Context fsGroup                                                  | `1001`                            |
| `proxy.podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                              |
| `proxy.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                            |
| `proxy.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                              |
| `proxy.nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set                                     | `""`                              |
| `proxy.nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set                                  | `[]`                              |
| `proxy.affinity`                              | Affinity for pod assignment. Evaluated as a template.                                     | `{}`                              |
| `proxy.nodeSelector`                          | Node labels for pod assignment. Evaluated as a template.                                  | `{}`                              |
| `proxy.tolerations`                           | Tolerations for pod assignment. Evaluated as a template.                                  | `[]`                              |
| `proxy.podLabels`                             | Extra labels for Proxy pods                                                               | `{}`                              |
| `proxy.podAnnotations`                        | Annotations for Proxy pods                                                                | `{}`                              |
| `proxy.lifecycleHooks`                        | Add lifecycle hooks to the Proxy deployment                                               | `{}`                              |
| `proxy.customStartupProbe`                    | Override default startup probe                                                            | `{}`                              |
| `proxy.customLivenessProbe`                   | Override default liveness probe                                                           | `{}`                              |
| `proxy.customReadinessProbe`                  | Override default readiness probe                                                          | `{}`                              |
| `proxy.updateStrategy.type`                   | Update strategy - only really applicable for deployments with RWO PVs attached            | `RollingUpdate`                   |
| `proxy.extraEnvVars`                          | Add extra environment variables to the Proxy container                                    | `[]`                              |
| `proxy.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars                                      | `""`                              |
| `proxy.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars                                         | `""`                              |
| `proxy.extraVolumes`                          | Optionally specify extra list of additional volumes for Proxy pods                        | `[]`                              |
| `proxy.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for Proxy container(s)           | `[]`                              |
| `proxy.initContainers`                        | Add additional init containers to the Proxy pods                                          | `[]`                              |
| `proxy.sidecars`                              | Add additional sidecar containers to the Proxy pod                                        | `[]`                              |


### Proxy Traffic Exposure Parameters

| Name                                            | Description                                                                                  | Value                    |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------- | ------------------------ |
| `proxy.networkPolicy.enabled`                   | Deploy Proxy network policies                                                                | `true`                   |
| `proxy.networkPolicy.allowInterspaceAccess`     | Allow communication between pods in different namespaces                                     | `true`                   |
| `proxy.networkPolicy.extraIngress`              | Add extra ingress rules to the NetworkPolicy                                                 | `""`                     |
| `proxy.networkPolicy.extraEgress`               | Add extra egress rules to the NetworkPolicy                                                  | `""`                     |
| `proxy.service.api.type`                        | API service type                                                                             | `ClusterIP`              |
| `proxy.service.api.port`                        | API service port                                                                             | `8001`                   |
| `proxy.service.api.loadBalancerIP`              | API service LoadBalancer IP (optional, cloud specific)                                       | `""`                     |
| `proxy.service.api.loadBalancerSourceRanges`    | loadBalancerIP source ranges for the Service                                                 | `[]`                     |
| `proxy.service.api.nodePorts.http`              | NodePort for the HTTP endpoint                                                               | `""`                     |
| `proxy.service.api.externalTrafficPolicy`       | External traffic policy for the service                                                      | `Cluster`                |
| `proxy.service.public.type`                     | Public service type                                                                          | `LoadBalancer`           |
| `proxy.service.public.port`                     | Public service port                                                                          | `80`                     |
| `proxy.service.public.loadBalancerIP`           | Public service LoadBalancer IP (optional, cloud specific)                                    | `""`                     |
| `proxy.service.public.loadBalancerSourceRanges` | loadBalancerIP source ranges for the Service                                                 | `[]`                     |
| `proxy.service.public.nodePorts.http`           | NodePort for the HTTP endpoint                                                               | `""`                     |
| `proxy.service.public.externalTrafficPolicy`    | External traffic policy for the service                                                      | `Cluster`                |
| `proxy.ingress.enabled`                         | Set to true to enable ingress record generation                                              | `false`                  |
| `proxy.ingress.path`                            | Path to the Proxy pod.                                                                       | `/`                      |
| `proxy.ingress.pathType`                        | Ingress path type                                                                            | `ImplementationSpecific` |
| `proxy.ingress.certManager`                     | Add cert-manager annotations to the Ingress object                                           | `false`                  |
| `proxy.ingress.hostname`                        | Set ingress rule hostname                                                                    | `jupyterhub.local`       |
| `proxy.ingress.annotations`                     | Add annotations to the Ingress object                                                        | `{}`                     |
| `proxy.ingress.tls`                             | Enable ingress tls configuration for the hostname defined at proxy.ingress.hostname          | `false`                  |
| `proxy.ingress.extraHosts`                      | The list of additional hostnames to be covered with this ingress record.                     | `[]`                     |
| `proxy.ingress.extraTls`                        | The tls configuration for additional hostnames to be covered with this ingress record.       | `[]`                     |
| `proxy.ingress.extraPaths`                      | Any additional arbitrary paths that may need to be added to the ingress under the main host. | `[]`                     |
| `proxy.ingress.secrets`                         | Add extra secrets for the tls configuration                                                  | `[]`                     |


### Image puller deployment parameters

| Name                                                | Description                                                                               | Value           |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------- | --------------- |
| `imagePuller.enabled`                               | Deploy ImagePuller daemonset                                                              | `true`          |
| `imagePuller.command`                               | Override ImagePuller default command                                                      | `[]`            |
| `imagePuller.args`                                  | Override ImagePuller default args                                                         | `[]`            |
| `imagePuller.hostAliases`                           | Add deployment host aliases                                                               | `[]`            |
| `imagePuller.resources.limits`                      | The resources limits for the container                                                    | `{}`            |
| `imagePuller.resources.requests`                    | The requested resources for the container                                                 | `{}`            |
| `imagePuller.containerSecurityContext.enabled`      | Enabled ImagePuller containers' Security Context                                          | `true`          |
| `imagePuller.containerSecurityContext.runAsUser`    | Set ImagePuller container's Security Context runAsUser                                    | `1001`          |
| `imagePuller.containerSecurityContext.runAsNonRoot` | Set ImagePuller container's Security Context runAsNonRoot                                 | `true`          |
| `imagePuller.podSecurityContext.enabled`            | Enabled ImagePuller pods' Security Context                                                | `true`          |
| `imagePuller.podSecurityContext.fsGroup`            | Set ImagePuller pod's Security Context fsGroup                                            | `1001`          |
| `imagePuller.podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `imagePuller.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `imagePuller.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `imagePuller.nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set                                     | `""`            |
| `imagePuller.nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set                                  | `[]`            |
| `imagePuller.affinity`                              | Affinity for pod assignment. Evaluated as a template.                                     | `{}`            |
| `imagePuller.nodeSelector`                          | Node labels for pod assignment. Evaluated as a template.                                  | `{}`            |
| `imagePuller.tolerations`                           | Tolerations for pod assignment. Evaluated as a template.                                  | `[]`            |
| `imagePuller.podLabels`                             | Pod extra labels                                                                          | `{}`            |
| `imagePuller.podAnnotations`                        | Annotations for ImagePuller pods                                                          | `{}`            |
| `imagePuller.priorityClassName`                     | ImagePuller pod priority class name                                                       | `""`            |
| `imagePuller.lifecycleHooks`                        | Add lifecycle hooks to the ImagePuller deployment                                         | `{}`            |
| `imagePuller.customStartupProbe`                    | Override default startup probe                                                            | `{}`            |
| `imagePuller.customLivenessProbe`                   | Override default liveness probe                                                           | `{}`            |
| `imagePuller.customReadinessProbe`                  | Override default readiness probe                                                          | `{}`            |
| `imagePuller.updateStrategy.type`                   | Update strategy - only really applicable for deployments with RWO PVs attached            | `RollingUpdate` |
| `imagePuller.extraEnvVars`                          | Add extra environment variables to the ImagePuller container                              | `[]`            |
| `imagePuller.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars                                      | `""`            |
| `imagePuller.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars                                         | `""`            |
| `imagePuller.extraVolumes`                          | Optionally specify extra list of additional volumes for ImagePuller pods                  | `[]`            |
| `imagePuller.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for ImagePuller container(s)     | `[]`            |
| `imagePuller.initContainers`                        | Add additional init containers to the ImagePuller pods                                    | `[]`            |
| `imagePuller.sidecars`                              | Add additional sidecar containers to the ImagePuller pod                                  | `[]`            |


### Singleuser deployment parameters

| Name                                            | Description                                                                                         | Value                                |
| ----------------------------------------------- | --------------------------------------------------------------------------------------------------- | ------------------------------------ |
| `singleuser.image.registry`                     | Single User image registry                                                                          | `docker.io`                          |
| `singleuser.image.repository`                   | Single User image repository                                                                        | `bitnami/jupyter-base-notebook`      |
| `singleuser.image.tag`                          | Single User image tag (immutabe tags are recommended)                                               | `1.4.2-debian-10-r33`                |
| `singleuser.image.pullPolicy`                   | Single User image pull policy                                                                       | `IfNotPresent`                       |
| `singleuser.image.pullSecrets`                  | Single User image pull secrets                                                                      | `[]`                                 |
| `singleuser.command`                            | Override Single User default command                                                                | `[]`                                 |
| `singleuser.tolerations`                        | Tolerations for pod assignment. Evaluated as a template.                                            | `[]`                                 |
| `singleuser.containerPort`                      | Single User container port                                                                          | `8888`                               |
| `singleuser.notebookDir`                        | Notebook directory (it will be the same as the PVC volume mount)                                    | `/opt/bitnami/jupyterhub-singleuser` |
| `singleuser.resources.limits`                   | The resources limits for the container                                                              | `{}`                                 |
| `singleuser.resources.requests`                 | The requested resources for the container                                                           | `{}`                                 |
| `singleuser.containerSecurityContext.enabled`   | Enabled Single User containers' Security Context                                                    | `true`                               |
| `singleuser.containerSecurityContext.runAsUser` | Set Single User container's Security Context runAsUser                                              | `1001`                               |
| `singleuser.podSecurityContext.enabled`         | Enabled Single User pods' Security Context                                                          | `true`                               |
| `singleuser.podSecurityContext.fsGroup`         | Set Single User pod's Security Context fsGroup                                                      | `1001`                               |
| `singleuser.nodeSelector`                       | Node labels for pod assignment. Evaluated as a template.                                            | `{}`                                 |
| `singleuser.podLabels`                          | Extra labels for Single User pods                                                                   | `{}`                                 |
| `singleuser.podAnnotations`                     | Annotations for Single User pods                                                                    | `{}`                                 |
| `singleuser.priorityClassName`                  | Single User pod priority class name                                                                 | `""`                                 |
| `singleuser.lifecycleHooks`                     | Add lifecycle hooks to the Single User deployment to automate configuration before or after startup | `{}`                                 |
| `singleuser.extraEnvVars`                       | Add extra environment variables to the Single User container                                        | `[]`                                 |
| `singleuser.extraVolumes`                       | Optionally specify extra list of additional volumes for Single User pods                            | `[]`                                 |
| `singleuser.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for Single User container(s)               | `[]`                                 |
| `singleuser.initContainers`                     | Add additional init containers to the Single User pods                                              | `[]`                                 |
| `singleuser.sidecars`                           | Add additional sidecar containers to the Single User pod                                            | `[]`                                 |


### Single User RBAC parameters

| Name                               | Description                                          | Value  |
| ---------------------------------- | ---------------------------------------------------- | ------ |
| `singleuser.serviceAccount.create` | Specifies whether a ServiceAccount should be created | `true` |
| `singleuser.serviceAccount.name`   | Override Single User service account name            | `""`   |


### Single User Persistence parameters

| Name                                  | Description                                                | Value               |
| ------------------------------------- | ---------------------------------------------------------- | ------------------- |
| `singleuser.persistence.enabled`      | Enable persistent volume creation on Single User instances | `true`              |
| `singleuser.persistence.storageClass` | Persistent Volumes storage class                           | `""`                |
| `singleuser.persistence.accessModes`  | Persistent Volumes access modes                            | `["ReadWriteOnce"]` |
| `singleuser.persistence.size`         | Persistent Volumes size                                    | `10Gi`              |


### Traffic exposure parameters

| Name                                                | Description                                              | Value   |
| --------------------------------------------------- | -------------------------------------------------------- | ------- |
| `singleuser.networkPolicy.enabled`                  | Deploy Single User network policies                      | `true`  |
| `singleuser.networkPolicy.allowInterspaceAccess`    | Allow communication between pods in different namespaces | `true`  |
| `singleuser.networkPolicy.allowCloudMetadataAccess` | Allow Single User pods to access Cloud Metada endpoints  | `false` |
| `singleuser.networkPolicy.extraIngress`             | Add extra ingress rules to the NetworkPolicy             | `""`    |
| `singleuser.networkPolicy.extraEgress`              | Add extra egress rules to the NetworkPolicy              | `""`    |


### Auxiliary image parameters

| Name                         | Description                                         | Value                   |
| ---------------------------- | --------------------------------------------------- | ----------------------- |
| `auxiliaryImage.registry`    | Auxiliary image registry                            | `docker.io`             |
| `auxiliaryImage.repository`  | Auxiliary image repository                          | `bitnami/bitnami-shell` |
| `auxiliaryImage.tag`         | Auxiliary image tag (immutabe tags are recommended) | `10-debian-10-r202`     |
| `auxiliaryImage.pullPolicy`  | Auxiliary image pull policy                         | `Always`                |
| `auxiliaryImage.pullSecrets` | Auxiliary image pull secrets                        | `[]`                    |


### External Database settings

| Name                              | Description                                                                                                     | Value        |
| --------------------------------- | --------------------------------------------------------------------------------------------------------------- | ------------ |
| `externalDatabase.host`           | Host of an external PostgreSQL instance to connect (only if postgresql.enabled=false)                           | `""`         |
| `externalDatabase.user`           | User of an external PostgreSQL instance to connect (only if postgresql.enabled=false)                           | `postgres`   |
| `externalDatabase.password`       | Password of an external PostgreSQL instance to connect (only if postgresql.enabled=false)                       | `""`         |
| `externalDatabase.existingSecret` | Secret containing the password of an external PostgreSQL instance to connect (only if postgresql.enabled=false) | `""`         |
| `externalDatabase.database`       | Database inside an external PostgreSQL to connect (only if postgresql.enabled=false)                            | `jupyterhub` |
| `externalDatabase.port`           | Port of an external PostgreSQL to connect (only if postgresql.enabled=false)                                    | `5432`       |


### PostgreSQL subchart settings

| Name                                   | Description                                                                        | Value                |
| -------------------------------------- | ---------------------------------------------------------------------------------- | -------------------- |
| `postgresql.enabled`                   | Deploy PostgreSQL subchart                                                         | `true`               |
| `postgresql.nameOverride`              | Override name of the PostgreSQL chart                                              | `""`                 |
| `postgresql.existingSecret`            | Existing secret containing the password of the PostgreSQL chart                    | `""`                 |
| `postgresql.postgresqlPassword`        | Password for the postgres user of the PostgreSQL chart (auto-generated if not set) | `""`                 |
| `postgresql.postgresqlUsername`        | Username to create when deploying the PostgreSQL chart                             | `bn_jupyterhub`      |
| `postgresql.postgresqlDatabase`        | Database to create when deploying the PostgreSQL chart                             | `bitnami_jupyterhub` |
| `postgresql.service.port`              | PostgreSQL service port                                                            | `5432`               |
| `postgresql.persistence.enabled`       | Use PVCs when deploying the PostgreSQL chart                                       | `true`               |
| `postgresql.persistence.existingClaim` | Use an existing PVC when deploying the PostgreSQL chart                            | `""`                 |
| `postgresql.persistence.storageClass`  | storageClass of the created PVCs                                                   | `""`                 |
| `postgresql.persistence.accessMode`    | Access mode of the created PVCs                                                    | `ReadWriteOnce`      |
| `postgresql.persistence.size`          | Size of the created PVCs                                                           | `8Gi`                |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set proxy.livenessProbe.successThreshold=5 \
    bitnami/jupyterhub
```

The above command sets the `proxy.livenessProbe.successThreshold` to `5`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/jupyterhub
```

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Configure authentication

The chart configures the Hub [DummyAuthenticator](https://github.com/jupyterhub/dummyauthenticator) by default, with the password set in the `hub.password` (auto-generated if not set) chart parameter and `user` as the administrator user. In order to change the authentication mechanism, change the `hub.config.JupyterHub` section inside the `hub.configuration` value.

Refer to the [chart documentation for a configuration example](https://docs.bitnami.com/kubernetes/infrastructure/jupyterhub/configuration/configure-authentication).

### Configure the Single User instances

As explained in the [documentation](https://docs.bitnami.com/kubernetes/infrastructure/jupyterhub/get-started/understand-default-configuration/), the Hub is responsible for deploying the Single User instances. The configuration of these instances is passed to the Hub instance via the `hub.configuration` chart parameter. The chart's `singleuser` section can be used to generate the `hub.configuration` value.

For more information, including how to provide a secret or a custom ConfigMap, refer to the [chart documentation on configuring Single User instances](https://docs.bitnami.com/kubernetes/infrastructure/jupyterhub/configuration/configure-single-user-instances/).

### Restrict traffic using NetworkPolicies

The Bitnami JupyterHub chart enables NetworkPolicies by default. This restricts the communication between the three main components: the Proxy, the Hub and the Single User instances. There are two elements that were left open on purpose:

- Ingress access to the Proxy instance HTTP port: by default, it is open to any IP, as it is the entry point to the JupyterHub instance. This behavior can be changed by tweaking the `proxy.networkPolicy.extraIngress` value.
- Hub egress access: As the Hub requires access to the Kubernetes API, the Hub can access to any IP by default (depending on the Kubernetes platform, the Service IP ranges can vary and so there is no easy way to detect the Kubernetes API internal IP). This behavior can be changed by tweaking the `hub.networkPolicy.extraEgress` value.

### Use sidecars and init containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `proxy.sidecars`, `hub.sidecars` or `singleuser.sidecars` config parameters. Similarly, extra init containers can be added using the `hub.initContainers`, `proxy.initContainers` and `singleuser.initContainers` parameters.

Refer to the chart documentation for more information on, and examples of, configuring and using [sidecars and init containers](https://docs.bitnami.com/kubernetes/infrastructure/jupyterhub/configuration/configure-sidecar-init-containers/).

### Configure Ingress

This chart provides support for Ingress resources for the JupyterHub proxy component. If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik), that Ingress controller can be used to serve WordPress.

To enable Ingress integration, set `proxy.ingress.enabled` to `true`. The `proxy.ingress.hostname` property can be used to set the host name. The `proxy.ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host.

Learn more about [configuring and using Ingress in the chart documentation](https://docs.bitnami.com/kubernetes/infrastructure/jupyterhub/configuration/configure-ingress/).

### Configure TLS secrets

This chart facilitates the creation of TLS secrets for use with the Ingress controller (although this is not mandatory). There are four common use cases:

* Helm generates/manages certificate secrets based on the parameters.
* User generates/manages certificates separately.
* Helm creates self-signed certificates and generates/manages certificate secrets.
* An additional tool (like [cert-manager](https://github.com/jetstack/cert-manager/)) manages the secrets for the application.

Refer to the [chart documentation for more information on working with TLS](https://docs.bitnami.com/kubernetes/infrastructure/jupyterhub/administration/enable-tls).

### Set pod affinity

This chart allows you to set your custom affinity using the `hub.affinity` and `proxy.affinity` parameters. Refer to the [chart documentation on pod affinity](https://docs.bitnami.com/kubernetes/infrastructure/jupyterhub/configuration/configure-pod-affinity).

### Deploy extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

```bash
$ helm upgrade my-release bitnami/jupyterhub
```
