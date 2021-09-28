# wavefront-prometheus-storage-adapter

[Wavefront Storage Adapter for Prometheus](https://github.com/wavefrontHQ/prometheus-storage-adapter) is a Prometheus integration to transfer metrics from Prometheus to Wavefront. It works as a "fork", such that data written to Prometheus is also written to Wavefront. It supports metrics path conversion and direct ingestion of metrics.
## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/wavefront-prometheus-storage-adapter
```

## Introduction
Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [Wavefront Storage Adapter for Prometheus](https://github.com/wavefrontHQ/prometheus-storage-adapter) Deployment in a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/wavefront-prometheus-storage-adapter
```

These commands deploy wavefront-prometheus-storage-adapter on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` helm release:

```console
$ helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                        | Value           |
| ------------------------- | -------------------------------------------------- | --------------- |
| `global.imageRegistry`    | Global Docker image registry                       | `""`            |
| `global.imagePullSecrets` | Global Docker registry secret names as an array    | `[]`            |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)       | `""`            |
| `kubeVersion`             | Override Kubernetes version                        | `""`            |
| `nameOverride`            | String to partially override common.names.fullname | `""`            |
| `fullnameOverride`        | String to fully override common.names.fullname     | `""`            |
| `commonLabels`            | Labels to add to all deployed objects              | `{}`            |
| `commonAnnotations`       | Annotations to add to all deployed objects         | `{}`            |
| `clusterDomain`           | Kubernetes cluster domain name                     | `cluster.local` |
| `extraDeploy`             | Array of extra objects to deploy with the release  | `[]`            |


### Wavefront Prometheus Storage Adapter deployment parameters

| Name                                    | Description                                                                               | Value                                          |
| --------------------------------------- | ----------------------------------------------------------------------------------------- | ---------------------------------------------- |
| `image.registry`                        | Adapter image registry                                                                    | `docker.io`                                    |
| `image.repository`                      | Adapter image repository                                                                  | `bitnami/wavefront-prometheus-storage-adapter` |
| `image.tag`                             | Adapter image tag (immutabe tags are recommended)                                         | `1.0.3-debian-10-r173`                         |
| `image.pullPolicy`                      | Adapter image pull policy                                                                 | `IfNotPresent`                                 |
| `image.pullSecrets`                     | Adapter image pull secrets                                                                | `[]`                                           |
| `image.debug`                           | Enable image debug mode                                                                   | `false`                                        |
| `livenessProbe.enabled`                 | Enable livenessProbe                                                                      | `true`                                         |
| `livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                   | `15`                                           |
| `livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                          | `10`                                           |
| `livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                         | `5`                                            |
| `livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                       | `5`                                            |
| `livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                       | `1`                                            |
| `readinessProbe.enabled`                | Enable readinessProbe                                                                     | `true`                                         |
| `readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                  | `15`                                           |
| `readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                         | `10`                                           |
| `readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                        | `5`                                            |
| `readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                      | `5`                                            |
| `readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                      | `1`                                            |
| `command`                               | Override default container command (useful when using custom images)                      | `[]`                                           |
| `args`                                  | Override default container args (useful when using custom images)                         | `[]`                                           |
| `hostAliases`                           | Add deployment host aliases                                                               | `[]`                                           |
| `resources.limits`                      | The resources limits for the Adapter container                                            | `{}`                                           |
| `resources.requests`                    | The requested resourcesc for the Adapter container                                        | `{}`                                           |
| `containerSecurityContext.enabled`      | Enabled Adapter containers' Security Context                                              | `true`                                         |
| `containerSecurityContext.runAsUser`    | Set Adapter container's Security Context runAsUser                                        | `1001`                                         |
| `containerSecurityContext.runAsNonRoot` | Set Adapter container's Security Context runAsNonRoot                                     | `true`                                         |
| `podSecurityContext.enabled`            | Enabled Adapter pods' Security Context                                                    | `true`                                         |
| `podSecurityContext.fsGroup`            | Set Adapter pod's Security Context fsGroup                                                | `1001`                                         |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                                           |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                                         |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                           |
| `nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set                                     | `""`                                           |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set                                  | `[]`                                           |
| `affinity`                              | Affinity for pod assignment                                                               | `{}`                                           |
| `nodeSelector`                          | Node labels for pod assignment                                                            | `{}`                                           |
| `tolerations`                           | Tolerations for pod assignment                                                            | `[]`                                           |
| `podLabels`                             | Extra labels for Adapter pods                                                             | `{}`                                           |
| `podAnnotations`                        | Annotations for Adapter pods                                                              | `{}`                                           |
| `priorityClassName`                     | Adapter pod priority                                                                      | `""`                                           |
| `lifecycleHooks`                        | Add lifecycle hooks to the Adapter deployment                                             | `{}`                                           |
| `customLivenessProbe`                   | Override default liveness probe                                                           | `{}`                                           |
| `customReadinessProbe`                  | Override default readiness probe                                                          | `{}`                                           |
| `updateStrategy.type`                   | Adapter deployment update strategy                                                        | `RollingUpdate`                                |
| `containerPort`                         | Adapter container port                                                                    | `1234`                                         |
| `extraEnvVars`                          | Add extra environment variables to the Adapter container                                  | `[]`                                           |
| `extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars                                      | `""`                                           |
| `extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars                                         | `""`                                           |
| `extraVolumes`                          | Optionally specify extra list of additional volumes for Adapter pods                      | `[]`                                           |
| `extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for Adapter container(s)         | `[]`                                           |
| `initContainers`                        | Add additional init containers to the Adapter pods                                        | `[]`                                           |
| `sidecars`                              | Add additional sidecar containers to the Adapter pod                                      | `[]`                                           |
| `externalProxy.host`                    | Host of a wavefront-proxy instance (required if wavefront.enabled = false)                | `""`                                           |
| `externalProxy.port`                    | Host of a wavefront-proxy instance (required if wavefront.enabled = false)                | `2878`                                         |
| `adapterPrefix`                         | Adapter `prefix` parameter                                                                | `""`                                           |
| `adapterTags`                           | Adapter `tags` parameter                                                                  | `""`                                           |


### Traffic Exposure Parameters

| Name                               | Description                                  | Value       |
| ---------------------------------- | -------------------------------------------- | ----------- |
| `service.type`                     | Adapter service type                         | `ClusterIP` |
| `service.port`                     | Adapter service port                         | `1234`      |
| `service.loadBalancerIP`           | Adapter service LoadBalancer IP              | `""`        |
| `service.loadBalancerSourceRanges` | loadBalancerIP source ranges for the Service | `[]`        |
| `service.nodePorts.http`           | NodePort for the HTTP endpoint               | `""`        |
| `service.externalTrafficPolicy`    | External traffic policy for the service      | `Cluster`   |


### Wavefront sub-chart parameters

| Name                              | Description                                                                               | Value                                |
| --------------------------------- | ----------------------------------------------------------------------------------------- | ------------------------------------ |
| `wavefront.enabled`               | Deploy Wavefront chart (necessary if externalProxyHost is not set)                        | `true`                               |
| `wavefront.wavefront.url`         | Wavefront SAAS service URL                                                                | `https://YOUR_CLUSTER.wavefront.com` |
| `wavefront.wavefront.token`       | Wavefront SAAS token                                                                      | `YOUR_API_TOKEN`                     |
| `wavefront.collector.enabled`     | Deploy Wavefront collector (not used by the Adapter pod)                                  | `false`                              |
| `wavefront.rbac.create`           | Create RBAC rules (not necessary as the Adapter only uses wavefront-proxy)                | `false`                              |
| `wavefront.proxy.enabled`         | Deploy Wavefront Proxy (required if externalProxyHost is not set)                         | `true`                               |
| `wavefront.proxy.port`            | Deployed Wavefront Proxy port (required if externalProxyHost is not set)                  | `2878`                               |
| `wavefront.serviceAccount.create` | Create Wavefront serivce account (not necessary as the Adapter only uses wavefront-proxy) | `false`                              |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set livenessProbe.successThreshold=5 \
    bitnami/wavefront-prometheus-storage-adapter
```

The above command sets the `livenessProbe.successThreshold` to `5`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/wavefront-prometheus-storage-adapter
```

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Connect to a Wavefront Proxy instance

The Wavefront Prometheus Storage Adapter chart needs to be connected to a Wavefront Proxy instance. This can be done in two different ways:

- Deploying the Wavefront subchart, using only the Wavefront Proxy component (default behavior): This is done by setting `wavefront.enabled=true` and `wavefront.proxy.enabled=true`, but leaving the `externalProxy.host` value unset. We recommend disabling the rest of the Wavefront sub-chart resources as they would not be used by the Prometheus Storage Adapter. You also need to configure the Wavefront SaaS URL and token using the `wavefont.wavefront.url` and `wavefront.wavefront.token` parameters.

- Using an external Wavefront Proxy instance: This is done by setting the `externalProxy.host` and `externalProxy.port` values. In this case, you should set the `wavefront.enabled` value to `false`. You also need to configure the Wavefront SaaS URL and token using the `wavefront.wavefront.url` and `wavefront.wavefront.token` parameters.

Refer to the [chart documentation for more detailed configuration examples](https://docs.bitnami.com/kubernetes/apps/wavefront-storage-adapter-for-prometheus/get-started/configure-connection/).

### Configure Prometheus

Once the Wavefront Prometheus Storage Adapter is deployed, you will need to configure the `prometheus.yml` file in your Prometheus installation adding the following lines (substitute the RELEASE_NAME placeholder):

```yaml
remote_write:
  - url: "http://RELEASE_NAME-wavefront-prometheus-storage-adapter:1234/receive"
```

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

```bash
$ helm upgrade my-release bitnami/wavefront-prometheus-storage-adapter
```

### To 1.0.0

This major updates the Wavefront subchart to its newest major release, 3.0.0, which contains a new major version for kube-state-metrics. For more information on this subchart's major version, please refer to the [Wavefront upgrade notes](https://github.com/bitnami/charts/tree/master/bitnami/wavefront#to-300).
