# Thanos

[Thanos](https://thanos.io/) is a highly available metrics system that can be added on top of existing Prometheus deployments, providing a global query view across all Prometheus installations.

## TL;DR

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/thanos
```

## Introduction

This chart bootstraps a [Thanos](https://github.com/bitnami/bitnami-docker-thanos) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/thanos
```

These commands deploy Thanos on the Kubernetes cluster with the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` chart:

```bash
helm uninstall my-release
```

## Architecture

This charts allows you install several Thanos components, so you deploy an architecture as the one below:

```
                       ┌──────────────┐                  ┌──────────────┐      ┌──────────────┐
                       │ Thanos       │───────────┬────▶ │ Thanos Store │      │ Thanos       │
                       │ Query        │           │      │ Gateway      │      │ Compactor    │
                       └──────────────┘           │      └──────────────┘      └──────────────┘
                   push                           │             │                     │
┌──────────────┐   alerts   ┌──────────────┐      │             │ storages            │ Downsample &
│ Alertmanager │ ◀──────────│ Thanos       │ ◀────┤             │ query metrics       │ compact blocks
│ (*)          │            │ Ruler        │      │             │                     │
└──────────────┘            └──────────────┘      │             ▼                     │
      ▲                            │              │      ┌────────────────┐           │
      │ push alerts                └──────────────│────▶ │ MinIO&reg; (*) │ ◀─────────┘
      │                                           │      │                │
┌ ── ── ── ── ── ── ── ── ── ──┐                  │      └────────────────┘
│┌────────────┐  ┌────────────┐│                  │             ▲
││ Prometheus │─▶│ Thanos     ││ ◀────────────────┘             │
││ (*)        │◀─│ Sidecar (*)││    query                       │ inspect
│└────────────┘  └────────────┘│    metrics                     │ blocks
└ ── ── ── ── ── ── ── ── ── ──┘                                │
                                                         ┌──────────────┐
                                                         │ Thanos       │
                                                         │ Bucket Web   │
                                                         └──────────────┘
```

> Note: Components marked with (*) are provided by subchart(s) (such as the [Bitnami MinIO&reg; chart](https://github.com/bitnami/charts/tree/master/bitnami/minio)) or external charts (such as the [Bitnami kube-prometheus chart](https://github.com/bitnami/charts/tree/master/bitnami/kube-prometheus)).

Check the section [Integrate Thanos with Prometheus and Alertmanager](#integrate-thanos-with-prometheus-and-alertmanager) for detailed instructions to deploy this architecture.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name               | Description                                                                                  | Value           |
| ------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`      | Force target Kubernetes version (using Helm capabilities if not set)                         | `""`            |
| `nameOverride`     | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride` | String to fully override common.names.fullname template                                      | `""`            |
| `commonLabels`     | Add labels to all the deployed resources                                                     | `{}`            |
| `clusterDomain`    | Kubernetes Cluster Domain                                                                    | `cluster.local` |


### Thanos common parameters

| Name                          | Description                                                                               | Value               |
| ----------------------------- | ----------------------------------------------------------------------------------------- | ------------------- |
| `image.registry`              | Thanos image registry                                                                     | `docker.io`         |
| `image.repository`            | Thanos image repository                                                                   | `bitnami/thanos`    |
| `image.tag`                   | Thanos image tag (immutable tags are recommended)                                         | `0.22.0-scratch-r4` |
| `image.pullPolicy`            | Thanos image pull policy                                                                  | `IfNotPresent`      |
| `image.pullSecrets`           | Specify docker-registry secret names as an array                                          | `[]`                |
| `objstoreConfig`              | The [objstore configuration](https://thanos.io/storage.md/)                               | `""`                |
| `indexCacheConfig`            | The [index cache configuration](https://thanos.io/components/store.md/)                   | `""`                |
| `bucketCacheConfig`           | The [bucket cache configuration](https://thanos.io/components/store.md/)                  | `""`                |
| `existingObjstoreSecret`      | Secret with Objstore Configuration                                                        | `""`                |
| `existingObjstoreSecretItems` | Optional item list for specifying a custom Secret key. If so, path should be objstore.yml | `[]`                |
| `existingServiceAccount`      | Provide a common service account to be shared with all components                         | `""`                |


### Thanos Query parameters

| Name                                                      | Description                                                                                                               | Value                    |
| --------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `query.enabled`                                           | Set to true to enable Thanos Query component                                                                              | `true`                   |
| `query.logLevel`                                          | Thanos Query log level                                                                                                    | `info`                   |
| `query.logFormat`                                         | Thanos Query log format                                                                                                   | `logfmt`                 |
| `query.serviceAccount.annotations`                        | Annotations for Thanos Query Service Account                                                                              | `{}`                     |
| `query.serviceAccount.existingServiceAccount`             | Provide an existing service account for query                                                                             | `""`                     |
| `query.hostAliases`                                       | Deployment pod host aliases                                                                                               | `[]`                     |
| `query.replicaLabel`                                      | Replica indicator(s) along which data is deduplicated                                                                     | `["replica"]`            |
| `query.dnsDiscovery.enabled`                              | Enable store APIs discovery via DNS                                                                                       | `true`                   |
| `query.dnsDiscovery.sidecarsService`                      | Sidecars service name to discover them using DNS discovery                                                                | `""`                     |
| `query.dnsDiscovery.sidecarsNamespace`                    | Sidecars namespace to discover them using DNS discovery                                                                   | `""`                     |
| `query.stores`                                            | Statically configure store APIs to connect with Thanos Query                                                              | `[]`                     |
| `query.sdConfig`                                          | Query Service Discovery Configuration                                                                                     | `""`                     |
| `query.existingSDConfigmap`                               | Name of existing ConfigMap with Ruler configuration                                                                       | `""`                     |
| `query.extraContainers`                                   | Extra containers running as sidecars to Thanos query                                                                      | `[]`                     |
| `query.extraEnv`                                          | Extra environment variables for Thanos query container                                                                    | `[]`                     |
| `query.extraVolumes`                                      | Extra volumes to add to Thanos Query                                                                                      | `[]`                     |
| `query.extraVolumeMounts`                                 | Extra volume mounts to add to the query container                                                                         | `[]`                     |
| `query.extraFlags`                                        | Extra Flags to passed to Thanos Query                                                                                     | `[]`                     |
| `query.replicaCount`                                      | Number of Thanos Query replicas to deploy                                                                                 | `1`                      |
| `query.strategyType`                                      | Deployment Strategy Type, can be set to RollingUpdate or Recreate by default                                              | `RollingUpdate`          |
| `query.podAffinityPreset`                                 | Thanos Query pod affinity preset                                                                                          | `""`                     |
| `query.podAntiAffinityPreset`                             | Thanos Query pod anti-affinity preset. Ignored if `query.affinity` is set. Allowed values: `soft` or `hard`               | `soft`                   |
| `query.nodeAffinityPreset.type`                           | Thanos Query node affinity preset type. Ignored if `query.affinity` is set. Allowed values: `soft` or `hard`              | `""`                     |
| `query.nodeAffinityPreset.key`                            | Thanos Query node label key to match Ignored if `query.affinity` is set.                                                  | `""`                     |
| `query.nodeAffinityPreset.values`                         | Thanos Query node label values to match. Ignored if `query.affinity` is set.                                              | `[]`                     |
| `query.affinity`                                          | Thanos Query affinity for pod assignment                                                                                  | `{}`                     |
| `query.nodeSelector`                                      | Thanos Query node labels for pod assignment                                                                               | `{}`                     |
| `query.tolerations`                                       | Thanos Query tolerations for pod assignment                                                                               | `[]`                     |
| `query.podLabels`                                         | Thanos Query pod labels                                                                                                   | `{}`                     |
| `query.podAnnotations`                                    | Annotations for Thanos Query pods                                                                                         | `{}`                     |
| `query.priorityClassName`                                 | Controller priorityClassName                                                                                              | `""`                     |
| `query.podSecurityContext.enabled`                        | Enable security context for the Thanos Query pod                                                                          | `true`                   |
| `query.podSecurityContext.fsGroup`                        | Group ID for the filesystem used by Query container                                                                       | `1001`                   |
| `query.podSecurityContext.runAsUser`                      | User ID for the service user running the Query pod                                                                        | `1001`                   |
| `query.containerSecurityContext.enabled`                  | Enable container security context for Query container                                                                     | `true`                   |
| `query.containerSecurityContext.runAsNonRoot`             | Force the container Query to run as a non root user                                                                       | `true`                   |
| `query.containerSecurityContext.allowPrivilegeEscalation` | Switch privilegeEscalation possiblity on or off for Query                                                                 | `false`                  |
| `query.containerSecurityContext.readOnlyRootFilesystem`   | mount / (root) as a readonly filesystem of Query container                                                                | `false`                  |
| `query.rbac.create`                                       | Create ClusterRole and ClusterRolebing for the Service account                                                            | `false`                  |
| `query.pspEnabled`                                        | Create PodSecurity Policy                                                                                                 | `false`                  |
| `query.resources.limits`                                  | The resources limits for the Thanos Query container                                                                       | `{}`                     |
| `query.resources.requests`                                | The requested resources for the Thanos Query container                                                                    | `{}`                     |
| `query.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                      | `true`                   |
| `query.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                   | `30`                     |
| `query.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                          | `10`                     |
| `query.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                         | `30`                     |
| `query.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                       | `6`                      |
| `query.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                       | `1`                      |
| `query.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                     | `true`                   |
| `query.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                  | `30`                     |
| `query.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                         | `10`                     |
| `query.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                        | `30`                     |
| `query.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                      | `6`                      |
| `query.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                      | `1`                      |
| `query.grpcTLS.server.secure`                             | Enable TLS for GRPC server                                                                                                | `false`                  |
| `query.grpcTLS.server.autoGenerated`                      | Create self-signed TLS certificates. Currently only supports PEM certificates.                                            | `false`                  |
| `query.grpcTLS.server.cert`                               | TLS Certificate for gRPC server, leave blank to disable TLS - ignored if existingSecret is provided                       | `""`                     |
| `query.grpcTLS.server.key`                                | TLS Key for the gRPC server, leave blank to disable TLS - ignored if existingSecret is provided                           | `""`                     |
| `query.grpcTLS.server.ca`                                 | TLS CA to verify clients against                                                                                          | `""`                     |
| `query.grpcTLS.server.existingSecret`                     | Existing secret containing your own TLS certificates.                                                                     | `{}`                     |
| `query.grpcTLS.client.secure`                             | Use TLS when talking to the gRPC server                                                                                   | `false`                  |
| `query.grpcTLS.client.autoGenerated`                      | Create self-signed TLS certificates. Currently only supports PEM certificates.                                            | `false`                  |
| `query.grpcTLS.client.cert`                               | TLS Certificates to use to identify this client to the server - ignored if existingSecret is provided                     | `""`                     |
| `query.grpcTLS.client.key`                                | TLS Key for the client's certificate - ignored if existingSecret is provided                                              | `""`                     |
| `query.grpcTLS.client.ca`                                 | TLS CA Certificates to use to verify gRPC servers - ignored if existingSecret is provided                                 | `""`                     |
| `query.grpcTLS.client.servername`                         | Server name to verify the hostname on the returned gRPC certificates. See https://tools.ietf.org/html/rfc4366#section-3.1 | `""`                     |
| `query.grpcTLS.client.existingSecret`                     | Existing secret containing your own TLS certificates.                                                                     | `{}`                     |
| `query.service.type`                                      | Kubernetes service type                                                                                                   | `ClusterIP`              |
| `query.service.clusterIP`                                 | Thanos Query service clusterIP IP                                                                                         | `""`                     |
| `query.service.http.port`                                 | Service HTTP port                                                                                                         | `9090`                   |
| `query.service.http.nodePort`                             | Service HTTP node port                                                                                                    | `""`                     |
| `query.service.targetPort`                                | Service targetPort override                                                                                               | `http`                   |
| `query.service.grpc.port`                                 | Service GRPC port                                                                                                         | `10901`                  |
| `query.service.grpc.nodePort`                             | Service GRPC node port                                                                                                    | `""`                     |
| `query.service.loadBalancerIP`                            | Load balancer IP if service type is `LoadBalancer`                                                                        | `""`                     |
| `query.service.loadBalancerSourceRanges`                  | Address that are allowed when service is LoadBalancer                                                                     | `[]`                     |
| `query.service.externalTrafficPolicy`                     | Thanos Query service externalTrafficPolicy                                                                                | `Cluster`                |
| `query.service.annotations`                               | Annotations for Thanos Query service                                                                                      | `{}`                     |
| `query.service.labelSelectorsOverride`                    | Selector for Thanos query service                                                                                         | `{}`                     |
| `query.autoscaling.enabled`                               | Enable autoscaling for Thanos Query                                                                                       | `false`                  |
| `query.autoscaling.minReplicas`                           | Minimum number of Thanos Query replicas                                                                                   | `""`                     |
| `query.autoscaling.maxReplicas`                           | Maximum number of Thanos Query replicas                                                                                   | `""`                     |
| `query.autoscaling.targetCPU`                             | Target CPU utilization percentage                                                                                         | `""`                     |
| `query.autoscaling.targetMemory`                          | Target Memory utilization percentage                                                                                      | `""`                     |
| `query.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                           | `false`                  |
| `query.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                            | `1`                      |
| `query.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                            | `""`                     |
| `query.ingress.enabled`                                   | Enable ingress controller resource                                                                                        | `false`                  |
| `query.ingress.certManager`                               | Set this to true in order to add the corresponding annotations for cert-manager                                           | `false`                  |
| `query.ingress.hostname`                                  | Default host for the ingress resource                                                                                     | `thanos.local`           |
| `query.ingress.ingressClassName`                          | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                             | `""`                     |
| `query.ingress.annotations`                               | Ingress annotations                                                                                                       | `{}`                     |
| `query.ingress.extraHosts`                                | The list of additional hostnames to be covered with this ingress record.                                                  | `[]`                     |
| `query.ingress.extraTls`                                  | The tls configuration for additional hostnames to be covered with this ingress record.                                    | `[]`                     |
| `query.ingress.secrets`                                   | If you're providing your own certificates, please use this to add the certificates as secrets                             | `[]`                     |
| `query.ingress.tls`                                       | Create ingress TLS section                                                                                                | `false`                  |
| `query.ingress.apiVersion`                                | Force Ingress API version (automatically detected if not set)                                                             | `""`                     |
| `query.ingress.path`                                      | Ingress path                                                                                                              | `/`                      |
| `query.ingress.pathType`                                  | Ingress path type                                                                                                         | `ImplementationSpecific` |
| `query.ingress.grpc.enabled`                              | Enable ingress controller resource (GRPC)                                                                                 | `false`                  |
| `query.ingress.grpc.certManager`                          | Add annotations for cert-manager (GRPC)                                                                                   | `false`                  |
| `query.ingress.grpc.hostname`                             | Default host for the ingress resource (GRPC)                                                                              | `thanos-grpc.local`      |
| `query.ingress.grpc.annotations`                          | Ingress annotations (GRPC)                                                                                                | `{}`                     |
| `query.ingress.grpc.extraHosts`                           | The list of additional hostnames to be covered with this ingress record.                                                  | `[]`                     |
| `query.ingress.grpc.extraTls`                             | The tls configuration for additional hostnames to be covered with this ingress record.                                    | `[]`                     |
| `query.ingress.grpc.secrets`                              | If you're providing your own certificates, please use this to add the certificates as secrets                             | `[]`                     |
| `query.ingress.grpc.apiVersion`                           | Override API Version (automatically detected if not set)                                                                  | `""`                     |
| `query.ingress.grpc.path`                                 | Ingress Path                                                                                                              | `/`                      |
| `query.ingress.grpc.pathType`                             | Ingress Path type                                                                                                         | `ImplementationSpecific` |


### Thanos Query Frontend parameters

| Name                                                              | Description                                                                                                                   | Value                    |
| ----------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `queryFrontend.enabled`                                           | Enable/disable Thanos Query Frontend component                                                                                | `true`                   |
| `queryFrontend.logLevel`                                          | Thanos Query Frontend log level                                                                                               | `info`                   |
| `queryFrontend.logFormat`                                         | Thanos Query Frontend log format                                                                                              | `logfmt`                 |
| `queryFrontend.serviceAccount.annotations`                        | Annotations for Thanos Query Frontend Service Account                                                                         | `{}`                     |
| `queryFrontend.serviceAccount.existingServiceAccount`             | Provide an existing service account for Query Frontend                                                                        | `""`                     |
| `queryFrontend.hostAliases`                                       | Deployment pod host aliases                                                                                                   | `[]`                     |
| `queryFrontend.extraContainers`                                   | Extra containers running as sidecars to Thanos Query Frontend container                                                       | `[]`                     |
| `queryFrontend.extraEnv`                                          | Extra environment variables for Thanos Query Frontend container                                                               | `[]`                     |
| `queryFrontend.extraVolumes`                                      | Extra volumes to add to Thanos Query Frontend                                                                                 | `[]`                     |
| `queryFrontend.extraVolumeMounts`                                 | Extra volume mounts to add to the query-frontend container                                                                    | `[]`                     |
| `queryFrontend.extraFlags`                                        | Extra Flags to passed to Thanos Query Frontend                                                                                | `[]`                     |
| `queryFrontend.config`                                            | Thanos Query Frontend cache configuration                                                                                     | `""`                     |
| `queryFrontend.existingConfigmap`                                 | Name of existing ConfigMap with Thanos Query Frontend cache configuration                                                     | `""`                     |
| `queryFrontend.replicaCount`                                      | Number of Thanos Query Frontend replicas to deploy                                                                            | `1`                      |
| `queryFrontend.strategyType`                                      | Deployment Strategy Type, can be set to RollingUpdate or Recreate by default                                                  | `RollingUpdate`          |
| `queryFrontend.podAffinityPreset`                                 | Thanos Query Frontend pod affinity preset                                                                                     | `""`                     |
| `queryFrontend.podAntiAffinityPreset`                             | Thanos Query Frontend pod anti-affinity preset. Ignored if `queryFrontend.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                   |
| `queryFrontend.nodeAffinityPreset.type`                           | Thanos Query Frontend node affinity preset type. Ignored if `queryFrontend.affinity` is set. Allowed values: `soft` or `hard` | `""`                     |
| `queryFrontend.nodeAffinityPreset.key`                            | Thanos Query Frontend node label key to match Ignored if `queryFrontend.affinity` is set.                                     | `""`                     |
| `queryFrontend.nodeAffinityPreset.values`                         | Thanos Query Frontend node label values to match. Ignored if `queryFrontend.affinity` is set.                                 | `[]`                     |
| `queryFrontend.affinity`                                          | Thanos Query Frontend affinity for pod assignment                                                                             | `{}`                     |
| `queryFrontend.nodeSelector`                                      | Thanos Query Frontend node labels for pod assignment                                                                          | `{}`                     |
| `queryFrontend.tolerations`                                       | Thanos Query Frontend tolerations for pod assignment                                                                          | `[]`                     |
| `queryFrontend.podLabels`                                         | Thanos Query Frontend pod labels                                                                                              | `{}`                     |
| `queryFrontend.podAnnotations`                                    | Annotations for Thanos Query Frontend pods                                                                                    | `{}`                     |
| `queryFrontend.priorityClassName`                                 | Controller priorityClassName                                                                                                  | `""`                     |
| `queryFrontend.podSecurityContext.enabled`                        | Enable security context for the Thanos Queryfrontend pod                                                                      | `true`                   |
| `queryFrontend.podSecurityContext.fsGroup`                        | Group ID for the filesystem used by Queryfrontend container                                                                   | `1001`                   |
| `queryFrontend.podSecurityContext.runAsUser`                      | User ID for the service user running the Queryfrontend pod                                                                    | `1001`                   |
| `queryFrontend.containerSecurityContext.enabled`                  | Enable container security context for Queryfrontend container                                                                 | `true`                   |
| `queryFrontend.containerSecurityContext.runAsNonRoot`             | Force the container Queryfrontend to run as a non root user                                                                   | `true`                   |
| `queryFrontend.containerSecurityContext.allowPrivilegeEscalation` | Switch privilegeEscalation possiblity on or off for Queryfrontend                                                             | `false`                  |
| `queryFrontend.containerSecurityContext.readOnlyRootFilesystem`   | mount / (root) as a readonly filesystem of Queryfrontend container                                                            | `false`                  |
| `queryFrontend.rbac.create`                                       | Create ClusterRole and ClusterRolebing for the Service account                                                                | `false`                  |
| `queryFrontend.pspEnabled`                                        | Create PodSecurity Policy                                                                                                     | `false`                  |
| `queryFrontend.resources.limits`                                  | The resources limits for the Thanos Query Frontend container                                                                  | `{}`                     |
| `queryFrontend.resources.requests`                                | The requested resources for the Thanos Query Frontend container                                                               | `{}`                     |
| `queryFrontend.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                          | `true`                   |
| `queryFrontend.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                       | `30`                     |
| `queryFrontend.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                              | `10`                     |
| `queryFrontend.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                             | `30`                     |
| `queryFrontend.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                           | `6`                      |
| `queryFrontend.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                           | `1`                      |
| `queryFrontend.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                         | `true`                   |
| `queryFrontend.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                      | `30`                     |
| `queryFrontend.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                             | `10`                     |
| `queryFrontend.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                            | `30`                     |
| `queryFrontend.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                          | `6`                      |
| `queryFrontend.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                          | `1`                      |
| `queryFrontend.service.type`                                      | Kubernetes service type                                                                                                       | `ClusterIP`              |
| `queryFrontend.service.clusterIP`                                 | Thanos Query Frontend service clusterIP IP                                                                                    | `""`                     |
| `queryFrontend.service.http.port`                                 | Service HTTP port                                                                                                             | `9090`                   |
| `queryFrontend.service.http.nodePort`                             | Service HTTP node port                                                                                                        | `""`                     |
| `queryFrontend.service.targetPort`                                | Service targetPort override                                                                                                   | `http`                   |
| `queryFrontend.service.loadBalancerIP`                            | Load balancer IP if service type is `LoadBalancer`                                                                            | `""`                     |
| `queryFrontend.service.loadBalancerSourceRanges`                  | Address that are allowed when service is LoadBalancer                                                                         | `[]`                     |
| `queryFrontend.service.externalTrafficPolicy`                     | Thanos Query Frontend service externalTrafficPolicy                                                                           | `Cluster`                |
| `queryFrontend.service.annotations`                               | Annotations for Thanos Query Frontend service                                                                                 | `{}`                     |
| `queryFrontend.service.labelSelectorsOverride`                    | Selector for Thanos query service                                                                                             | `{}`                     |
| `queryFrontend.autoscaling.enabled`                               | Enable autoscaling for Thanos Query Frontend                                                                                  | `false`                  |
| `queryFrontend.autoscaling.minReplicas`                           | Minimum number of Thanos Query Frontend replicas                                                                              | `""`                     |
| `queryFrontend.autoscaling.maxReplicas`                           | Maximum number of Thanos Query Frontend replicas                                                                              | `""`                     |
| `queryFrontend.autoscaling.targetCPU`                             | Target CPU utilization percentage                                                                                             | `""`                     |
| `queryFrontend.autoscaling.targetMemory`                          | Target Memory utilization percentage                                                                                          | `""`                     |
| `queryFrontend.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                               | `false`                  |
| `queryFrontend.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                | `1`                      |
| `queryFrontend.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                | `""`                     |
| `queryFrontend.ingress.enabled`                                   | Enable ingress controller resource                                                                                            | `false`                  |
| `queryFrontend.ingress.certManager`                               | Set this to true in order to add the corresponding annotations for cert-manager                                               | `false`                  |
| `queryFrontend.ingress.hostname`                                  | Default host for the ingress resource                                                                                         | `thanos.local`           |
| `queryFrontend.ingress.ingressClassName`                          | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                 | `""`                     |
| `queryFrontend.ingress.annotations`                               | Ingress annotations                                                                                                           | `{}`                     |
| `queryFrontend.ingress.extraHosts`                                | The list of additional hostnames to be covered with this ingress record.                                                      | `[]`                     |
| `queryFrontend.ingress.extraTls`                                  | The tls configuration for additional hostnames to be covered with this ingress record.                                        | `[]`                     |
| `queryFrontend.ingress.secrets`                                   | If you're providing your own certificates, please use this to add the certificates as secrets                                 | `[]`                     |
| `queryFrontend.ingress.tls`                                       | Create ingress TLS section                                                                                                    | `false`                  |
| `queryFrontend.ingress.apiVersion`                                | Force Ingress API version (automatically detected if not set)                                                                 | `""`                     |
| `queryFrontend.ingress.path`                                      | Ingress path                                                                                                                  | `/`                      |
| `queryFrontend.ingress.pathType`                                  | Ingress path type                                                                                                             | `ImplementationSpecific` |


### Thanos Bucket Web parameters

| Name                                                          | Description                                                                                                           | Value                    |
| ------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `bucketweb.enabled`                                           | Enable/disable Thanos Bucket Web component                                                                            | `false`                  |
| `bucketweb.logLevel`                                          | Thanos Bucket Web log level                                                                                           | `info`                   |
| `bucketweb.logFormat`                                         | Thanos Bucket Web log format                                                                                          | `logfmt`                 |
| `bucketweb.serviceAccount.annotations`                        | Annotations for Thanos Bucket Web Service Account                                                                     | `{}`                     |
| `bucketweb.serviceAccount.existingServiceAccount`             | Name for an existing Thanos Bucket Web Service Account                                                                | `""`                     |
| `bucketweb.refresh`                                           | Refresh interval to download metadata from remote storage                                                             | `30m`                    |
| `bucketweb.hostAliases`                                       | Deployment pod host aliases                                                                                           | `[]`                     |
| `bucketweb.timeout`                                           | Timeout to download metadata from remote storage                                                                      | `5m`                     |
| `bucketweb.extraContainers`                                   | Extra containers running as sidecars to Thanos Bucket Web container                                                   | `[]`                     |
| `bucketweb.extraEnv`                                          | Extra environment variables for Thanos Bucket Web container                                                           | `[]`                     |
| `bucketweb.extraVolumes`                                      | Extra volumes to add to Bucket Web                                                                                    | `[]`                     |
| `bucketweb.extraVolumeMounts`                                 | Extra volume mounts to add to the bucketweb container                                                                 | `[]`                     |
| `bucketweb.extraFlags`                                        | Extra Flags to passed to Thanos Bucket Web                                                                            | `[]`                     |
| `bucketweb.replicaCount`                                      | Number of Thanos Bucket Web replicas to deploy                                                                        | `1`                      |
| `bucketweb.strategyType`                                      | Deployment Strategy Type, can be set to RollingUpdate or Recreate by default                                          | `RollingUpdate`          |
| `bucketweb.podAffinityPreset`                                 | Thanos Bucket Web pod affinity preset                                                                                 | `""`                     |
| `bucketweb.podAntiAffinityPreset`                             | Thanos Bucket Web pod anti-affinity preset. Ignored if `bucketweb.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                   |
| `bucketweb.nodeAffinityPreset.type`                           | Thanos Bucket Web node affinity preset type. Ignored if `bucketweb.affinity` is set. Allowed values: `soft` or `hard` | `""`                     |
| `bucketweb.nodeAffinityPreset.key`                            | Thanos Bucket Web node label key to match Ignored if `bucketweb.affinity` is set.                                     | `""`                     |
| `bucketweb.nodeAffinityPreset.values`                         | Thanos Bucket Web node label values to match. Ignored if `bucketweb.affinity` is set.                                 | `[]`                     |
| `bucketweb.affinity`                                          | Thanos Bucket Web affinity for pod assignment                                                                         | `{}`                     |
| `bucketweb.nodeSelector`                                      | Thanos Bucket Web node labels for pod assignment                                                                      | `{}`                     |
| `bucketweb.tolerations`                                       | Thanos Bucket Web tolerations for pod assignment                                                                      | `[]`                     |
| `bucketweb.podLabels`                                         | Thanos Bucket Web pod labels                                                                                          | `{}`                     |
| `bucketweb.podAnnotations`                                    | Annotations for Thanos Bucket Web pods                                                                                | `{}`                     |
| `bucketweb.priorityClassName`                                 | Controller priorityClassName                                                                                          | `""`                     |
| `bucketweb.podSecurityContext.enabled`                        | Enable security context for the Thanos Bucketweb pod                                                                  | `true`                   |
| `bucketweb.podSecurityContext.fsGroup`                        | Group ID for the filesystem used by Bucketweb container                                                               | `1001`                   |
| `bucketweb.podSecurityContext.runAsUser`                      | User ID for the service user running the Bucketweb pod                                                                | `1001`                   |
| `bucketweb.containerSecurityContext.enabled`                  | Enable container security context for Bucketweb container                                                             | `true`                   |
| `bucketweb.containerSecurityContext.runAsNonRoot`             | Force the container Bucketweb to run as a non root user                                                               | `true`                   |
| `bucketweb.containerSecurityContext.allowPrivilegeEscalation` | Switch privilegeEscalation possiblity on or off for Bucketweb                                                         | `false`                  |
| `bucketweb.containerSecurityContext.readOnlyRootFilesystem`   | mount / (root) as a readonly filesystem of Bucketweb container                                                        | `false`                  |
| `bucketweb.resources.limits`                                  | The resources limits for the Thanos Bucket Web container                                                              | `{}`                     |
| `bucketweb.resources.requests`                                | The requested resources for the Thanos Bucket Web container                                                           | `{}`                     |
| `bucketweb.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                  | `true`                   |
| `bucketweb.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                               | `30`                     |
| `bucketweb.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                      | `10`                     |
| `bucketweb.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                     | `30`                     |
| `bucketweb.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                   | `6`                      |
| `bucketweb.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                   | `1`                      |
| `bucketweb.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                 | `true`                   |
| `bucketweb.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                              | `30`                     |
| `bucketweb.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                     | `10`                     |
| `bucketweb.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                    | `30`                     |
| `bucketweb.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                  | `6`                      |
| `bucketweb.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                  | `1`                      |
| `bucketweb.service.type`                                      | Kubernetes service type                                                                                               | `ClusterIP`              |
| `bucketweb.service.clusterIP`                                 | Thanos Bucket Web service clusterIP IP                                                                                | `""`                     |
| `bucketweb.service.http.port`                                 | Service HTTP port                                                                                                     | `8080`                   |
| `bucketweb.service.http.nodePort`                             | Service HTTP node port                                                                                                | `""`                     |
| `bucketweb.service.targetPort`                                | Service targetPort override                                                                                           | `http`                   |
| `bucketweb.service.loadBalancerIP`                            | Load balancer IP if service type is `LoadBalancer`                                                                    | `""`                     |
| `bucketweb.service.loadBalancerSourceRanges`                  | Address that are allowed when service is LoadBalancer                                                                 | `[]`                     |
| `bucketweb.service.externalTrafficPolicy`                     | Thanos Bucket Web service externalTrafficPolicy                                                                       | `Cluster`                |
| `bucketweb.service.annotations`                               | Annotations for Thanos Bucket Web service                                                                             | `{}`                     |
| `bucketweb.service.labelSelectorsOverride`                    | Selector for Thanos query service                                                                                     | `{}`                     |
| `bucketweb.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                       | `false`                  |
| `bucketweb.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                        | `1`                      |
| `bucketweb.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                        | `""`                     |
| `bucketweb.ingress.enabled`                                   | Enable ingress controller resource                                                                                    | `false`                  |
| `bucketweb.ingress.certManager`                               | Add annotations for cert-manager                                                                                      | `false`                  |
| `bucketweb.ingress.hostname`                                  | Default host for the ingress resource                                                                                 | `thanos-bucketweb.local` |
| `bucketweb.ingress.ingressClassName`                          | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                         | `""`                     |
| `bucketweb.ingress.annotations`                               | Ingress annotations                                                                                                   | `{}`                     |
| `bucketweb.ingress.extraHosts`                                | The list of additional hostnames to be covered with this ingress record.                                              | `[]`                     |
| `bucketweb.ingress.extraTls`                                  | The tls configuration for additional hostnames to be covered with this ingress record.                                | `[]`                     |
| `bucketweb.ingress.secrets`                                   | If you're providing your own certificates, please use this to add the certificates as secrets                         | `[]`                     |
| `bucketweb.ingress.tls`                                       | Create ingress TLS section                                                                                            | `false`                  |
| `bucketweb.ingress.apiVersion`                                | Force Ingress API version (automatically detected if not set)                                                         | `""`                     |
| `bucketweb.ingress.path`                                      | Ingress path                                                                                                          | `/`                      |
| `bucketweb.ingress.pathType`                                  | Ingress path type                                                                                                     | `ImplementationSpecific` |


### Thanos Compactor parameters

| Name                                                          | Description                                                                                                          | Value                    |
| ------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `compactor.enabled`                                           | Enable/disable Thanos Compactor component                                                                            | `false`                  |
| `compactor.logLevel`                                          | Thanos Compactor log level                                                                                           | `info`                   |
| `compactor.logFormat`                                         | Thanos Compactor log format                                                                                          | `logfmt`                 |
| `compactor.serviceAccount.annotations`                        | Annotations for Thanos Compactor Service Account                                                                     | `{}`                     |
| `compactor.serviceAccount.existingServiceAccount`             | Name for an existing Thanos Compactor Service Account                                                                | `""`                     |
| `compactor.hostAliases`                                       | Deployment pod host aliases                                                                                          | `[]`                     |
| `compactor.retentionResolutionRaw`                            | Resolution and Retention flag                                                                                        | `30d`                    |
| `compactor.retentionResolution5m`                             | Resolution and Retention flag                                                                                        | `30d`                    |
| `compactor.retentionResolution1h`                             | Resolution and Retention flag                                                                                        | `10y`                    |
| `compactor.consistencyDelay`                                  | Minimum age of fresh (non-compacted) blocks before they are being processed                                          | `30m`                    |
| `compactor.extraEnv`                                          | Extra environment variables for Thanos Compactor container                                                           | `[]`                     |
| `compactor.extraVolumes`                                      | Extra volumes to add to Thanos Compactor                                                                             | `[]`                     |
| `compactor.extraVolumeMounts`                                 | Extra volume mounts to add to the compactor container                                                                | `[]`                     |
| `compactor.extraFlags`                                        | Extra Flags to passed to Thanos Compactor                                                                            | `[]`                     |
| `compactor.strategyType`                                      | Deployment Strategy Type, can be set to RollingUpdate or Recreate by default                                         | `RollingUpdate`          |
| `compactor.podAffinityPreset`                                 | Thanos Compactor pod affinity preset                                                                                 | `""`                     |
| `compactor.podAntiAffinityPreset`                             | Thanos Compactor pod anti-affinity preset. Ignored if `compactor.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                   |
| `compactor.nodeAffinityPreset.type`                           | Thanos Compactor node affinity preset type. Ignored if `compactor.affinity` is set. Allowed values: `soft` or `hard` | `""`                     |
| `compactor.nodeAffinityPreset.key`                            | Thanos Compactor node label key to match Ignored if `compactor.affinity` is set.                                     | `""`                     |
| `compactor.nodeAffinityPreset.values`                         | Thanos Compactor node label values to match. Ignored if `compactor.affinity` is set.                                 | `[]`                     |
| `compactor.affinity`                                          | Thanos Compactor affinity for pod assignment                                                                         | `{}`                     |
| `compactor.nodeSelector`                                      | Thanos Compactor node labels for pod assignment                                                                      | `{}`                     |
| `compactor.tolerations`                                       | Thanos Compactor tolerations for pod assignment                                                                      | `[]`                     |
| `compactor.podLabels`                                         | Thanos Compactor pod labels                                                                                          | `{}`                     |
| `compactor.podAnnotations`                                    | Annotations for Thanos Compactor pods                                                                                | `{}`                     |
| `compactor.priorityClassName`                                 | Controller priorityClassName                                                                                         | `""`                     |
| `compactor.podSecurityContext.enabled`                        | Enable security context for the Thanos Compactor pod                                                                 | `true`                   |
| `compactor.podSecurityContext.fsGroup`                        | Group ID for the filesystem used by Compactor container                                                              | `1001`                   |
| `compactor.podSecurityContext.runAsUser`                      | User ID for the service user running the Compactor pod                                                               | `1001`                   |
| `compactor.containerSecurityContext.enabled`                  | Enable container security context for Compactor container                                                            | `true`                   |
| `compactor.containerSecurityContext.runAsNonRoot`             | Force the container Compactor to run as a non root user                                                              | `true`                   |
| `compactor.containerSecurityContext.allowPrivilegeEscalation` | Switch privilegeEscalation possiblity on or off for Compactor                                                        | `false`                  |
| `compactor.containerSecurityContext.readOnlyRootFilesystem`   | mount / (root) as a readonly filesystem of Compactor container                                                       | `false`                  |
| `compactor.resources.limits`                                  | The resources limits for the Thanos Compactor container                                                              | `{}`                     |
| `compactor.resources.requests`                                | The requested resources for the Thanos Compactor container                                                           | `{}`                     |
| `compactor.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                 | `true`                   |
| `compactor.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                              | `30`                     |
| `compactor.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                     | `10`                     |
| `compactor.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                    | `30`                     |
| `compactor.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                  | `6`                      |
| `compactor.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                  | `1`                      |
| `compactor.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                | `true`                   |
| `compactor.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                             | `30`                     |
| `compactor.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                    | `10`                     |
| `compactor.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                   | `30`                     |
| `compactor.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                 | `6`                      |
| `compactor.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                 | `1`                      |
| `compactor.service.type`                                      | Kubernetes service type                                                                                              | `ClusterIP`              |
| `compactor.service.clusterIP`                                 | Thanos Compactor service clusterIP IP                                                                                | `""`                     |
| `compactor.service.http.port`                                 | Service HTTP port                                                                                                    | `9090`                   |
| `compactor.service.http.nodePort`                             | Service HTTP node port                                                                                               | `""`                     |
| `compactor.service.loadBalancerIP`                            | Load balancer IP if service type is `LoadBalancer`                                                                   | `""`                     |
| `compactor.service.loadBalancerSourceRanges`                  | Addresses that are allowed when service is LoadBalancer                                                              | `[]`                     |
| `compactor.service.externalTrafficPolicy`                     | Thanos Compactor service externalTrafficPolicy                                                                       | `Cluster`                |
| `compactor.service.annotations`                               | Annotations for Thanos Compactor service                                                                             | `{}`                     |
| `compactor.service.labelSelectorsOverride`                    | Selector for Thanos query service                                                                                    | `{}`                     |
| `compactor.ingress.enabled`                                   | Enable ingress controller resource                                                                                   | `false`                  |
| `compactor.ingress.certManager`                               | Set this to true in order to add the corresponding annotations for cert-manager                                      | `false`                  |
| `compactor.ingress.hostname`                                  | Default host for the ingress resource                                                                                | `thanos-compactor.local` |
| `compactor.ingress.ingressClassName`                          | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                        | `""`                     |
| `compactor.ingress.annotations`                               | Ingress annotations                                                                                                  | `{}`                     |
| `compactor.ingress.extraHosts`                                | The list of additional hostnames to be covered with this ingress record.                                             | `[]`                     |
| `compactor.ingress.extraTls`                                  | The tls configuration for additional hostnames to be covered with this ingress record.                               | `[]`                     |
| `compactor.ingress.secrets`                                   | If you're providing your own certificates, please use this to add the certificates as secrets                        | `[]`                     |
| `compactor.ingress.tls`                                       | Create ingress TLS section                                                                                           | `false`                  |
| `compactor.ingress.apiVersion`                                | Force Ingress API version (automatically detected if not set)                                                        | `""`                     |
| `compactor.ingress.path`                                      | Ingress path                                                                                                         | `/`                      |
| `compactor.ingress.pathType`                                  | Ingress path type                                                                                                    | `ImplementationSpecific` |
| `compactor.persistence.enabled`                               | Enable data persistence                                                                                              | `true`                   |
| `compactor.persistence.existingClaim`                         | Use a existing PVC which must be created manually before bound                                                       | `""`                     |
| `compactor.persistence.storageClass`                          | Specify the `storageClass` used to provision the volume                                                              | `""`                     |
| `compactor.persistence.accessModes`                           | Access modes of data volume                                                                                          | `["ReadWriteOnce"]`      |
| `compactor.persistence.size`                                  | Size of data volume                                                                                                  | `8Gi`                    |


### Thanos Store Gateway parameters

| Name                                                             | Description                                                                                                                              | Value                       |
| ---------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- | --------------------------- |
| `storegateway.enabled`                                           | Enable/disable Thanos Store Gateway component                                                                                            | `false`                     |
| `storegateway.logLevel`                                          | Thanos Store Gateway log level                                                                                                           | `info`                      |
| `storegateway.logFormat`                                         | Thanos Store Gateway log format                                                                                                          | `logfmt`                    |
| `storegateway.serviceAccount.annotations`                        | Annotations for Thanos Store Gateway Service Account                                                                                     | `{}`                        |
| `storegateway.serviceAccount.existingServiceAccount`             | Name for an existing Thanos Store Gateway Service Account                                                                                | `""`                        |
| `storegateway.hostAliases`                                       | Deployment pod host aliases                                                                                                              | `[]`                        |
| `storegateway.extraEnv`                                          | Extra environment variables for Thanos Store Gateway container                                                                           | `[]`                        |
| `storegateway.extraVolumes`                                      | Extra volumes to add to Thanos Store Gateway                                                                                             | `[]`                        |
| `storegateway.extraVolumeMounts`                                 | Extra volume mounts to add to the storegateway container                                                                                 | `[]`                        |
| `storegateway.extraFlags`                                        | Extra Flags to passed to Thanos Store Gateway                                                                                            | `[]`                        |
| `storegateway.config`                                            | Thanos Store Gateway cache configuration                                                                                                 | `""`                        |
| `storegateway.existingConfigmap`                                 | Name of existing ConfigMap with Thanos Store Gateway cache configuration                                                                 | `""`                        |
| `storegateway.grpc.tls.enabled`                                  | Enable TLS encryption in the GRPC server                                                                                                 | `false`                     |
| `storegateway.grpc.tls.autoGenerated`                            | Create self-signed TLS certificates. Currently only supports PEM certificates.                                                           | `false`                     |
| `storegateway.grpc.tls.cert`                                     | TLS Certificate for gRPC server, leave blank to disable TLS - ignored if existingSecret is provided                                      | `""`                        |
| `storegateway.grpc.tls.key`                                      | TLS Key for gRPC server, leave blank to disable TLS - ignored if existingSecret is provided                                              | `""`                        |
| `storegateway.grpc.tls.ca`                                       | TLS CA to verify clients against - ignored if existingSecret is provided                                                                 | `""`                        |
| `storegateway.grpc.tls.existingSecret`                           | Existing secret containing your own TLS certificates.                                                                                    | `{}`                        |
| `storegateway.replicaCount`                                      | Number of Thanos Store Gateway replicas to deploy                                                                                        | `1`                         |
| `storegateway.updateStrategyType`                                | Statefulset Update Strategy Type, can be set to RollingUpdate or OnDelete by default                                                     | `RollingUpdate`             |
| `storegateway.podManagementPolicy`                               | Statefulset Pod management policy: OrderedReady (default) or Parallel                                                                    | `OrderedReady`              |
| `storegateway.podAffinityPreset`                                 | Thanos Store Gateway pod affinity preset                                                                                                 | `""`                        |
| `storegateway.podAntiAffinityPreset`                             | Thanos Store Gateway pod anti-affinity preset. Ignored if `storegateway.affinity` is set. Allowed values: `soft` or `hard`               | `soft`                      |
| `storegateway.nodeAffinityPreset.type`                           | Thanos Store Gateway node affinity preset type. Ignored if `storegateway.affinity` is set. Allowed values: `soft` or `hard`              | `""`                        |
| `storegateway.nodeAffinityPreset.key`                            | Thanos Store Gateway node label key to match Ignored if `storegateway.affinity` is set.                                                  | `""`                        |
| `storegateway.nodeAffinityPreset.values`                         | Thanos Store Gateway node label values to match. Ignored if `storegateway.affinity` is set.                                              | `[]`                        |
| `storegateway.affinity`                                          | Thanos Store Gateway affinity for pod assignment                                                                                         | `{}`                        |
| `storegateway.nodeSelector`                                      | Thanos Store Gateway node labels for pod assignment                                                                                      | `{}`                        |
| `storegateway.tolerations`                                       | Thanos Store Gateway tolerations for pod assignment                                                                                      | `[]`                        |
| `storegateway.podLabels`                                         | Thanos Store Gateway pod labels                                                                                                          | `{}`                        |
| `storegateway.podAnnotations`                                    | Annotations for Thanos Store Gateway pods                                                                                                | `{}`                        |
| `storegateway.priorityClassName`                                 | Controller priorityClassName                                                                                                             | `""`                        |
| `storegateway.podSecurityContext.enabled`                        | Enable security context for the Thanos Storegateway pod                                                                                  | `true`                      |
| `storegateway.podSecurityContext.fsGroup`                        | Group ID for the filesystem used by Storegateway container                                                                               | `1001`                      |
| `storegateway.podSecurityContext.runAsUser`                      | User ID for the service user running the Storegateway pod                                                                                | `1001`                      |
| `storegateway.containerSecurityContext.enabled`                  | Enable container security context for Storegateway container                                                                             | `true`                      |
| `storegateway.containerSecurityContext.runAsNonRoot`             | Force the container Storegateway to run as a non root user                                                                               | `true`                      |
| `storegateway.containerSecurityContext.allowPrivilegeEscalation` | Switch privilegeEscalation possiblity on or off for Storegateway                                                                         | `false`                     |
| `storegateway.containerSecurityContext.readOnlyRootFilesystem`   | mount / (root) as a readonly filesystem of Storegateway container                                                                        | `false`                     |
| `storegateway.resources.limits`                                  | The resources limits for the Thanos Store Gateway container                                                                              | `{}`                        |
| `storegateway.resources.requests`                                | The requested resources for the Thanos Store Gateway container                                                                           | `{}`                        |
| `storegateway.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                     | `true`                      |
| `storegateway.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                  | `30`                        |
| `storegateway.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                         | `10`                        |
| `storegateway.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                        | `30`                        |
| `storegateway.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                      | `6`                         |
| `storegateway.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                      | `1`                         |
| `storegateway.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                    | `true`                      |
| `storegateway.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                 | `30`                        |
| `storegateway.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                        | `10`                        |
| `storegateway.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                       | `30`                        |
| `storegateway.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                     | `6`                         |
| `storegateway.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                     | `1`                         |
| `storegateway.service.type`                                      | Kubernetes service type                                                                                                                  | `ClusterIP`                 |
| `storegateway.service.clusterIP`                                 | Thanos Store Gateway service clusterIP IP                                                                                                | `""`                        |
| `storegateway.service.http.port`                                 | Service HTTP port                                                                                                                        | `9090`                      |
| `storegateway.service.http.nodePort`                             | Service HTTP node port                                                                                                                   | `""`                        |
| `storegateway.service.grpc.port`                                 | Service GRPC port                                                                                                                        | `10901`                     |
| `storegateway.service.grpc.nodePort`                             | Service GRPC node port                                                                                                                   | `""`                        |
| `storegateway.service.loadBalancerIP`                            | Load balancer IP if service type is `LoadBalancer`                                                                                       | `""`                        |
| `storegateway.service.loadBalancerSourceRanges`                  | Addresses that are allowed when service is LoadBalancer                                                                                  | `[]`                        |
| `storegateway.service.externalTrafficPolicy`                     | Thanos Store Gateway service externalTrafficPolicy                                                                                       | `Cluster`                   |
| `storegateway.service.annotations`                               | Annotations for Thanos Store Gateway service                                                                                             | `{}`                        |
| `storegateway.service.labelSelectorsOverride`                    | Selector for Thanos query service                                                                                                        | `{}`                        |
| `storegateway.service.additionalHeadless`                        | Additional Headless service                                                                                                              | `false`                     |
| `storegateway.persistence.enabled`                               | Enable data persistence                                                                                                                  | `true`                      |
| `storegateway.persistence.existingClaim`                         | Use a existing PVC which must be created manually before bound                                                                           | `""`                        |
| `storegateway.persistence.storageClass`                          | Specify the `storageClass` used to provision the volume                                                                                  | `""`                        |
| `storegateway.persistence.accessModes`                           | Access modes of data volume                                                                                                              | `["ReadWriteOnce"]`         |
| `storegateway.persistence.size`                                  | Size of data volume                                                                                                                      | `8Gi`                       |
| `storegateway.autoscaling.enabled`                               | Enable autoscaling for Thanos Store Gateway                                                                                              | `false`                     |
| `storegateway.autoscaling.minReplicas`                           | Minimum number of Thanos Store Gateway replicas                                                                                          | `""`                        |
| `storegateway.autoscaling.maxReplicas`                           | Maximum number of Thanos Store Gateway replicas                                                                                          | `""`                        |
| `storegateway.autoscaling.targetCPU`                             | Target CPU utilization percentage                                                                                                        | `""`                        |
| `storegateway.autoscaling.targetMemory`                          | Target Memory utilization percentage                                                                                                     | `""`                        |
| `storegateway.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                          | `false`                     |
| `storegateway.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                           | `1`                         |
| `storegateway.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                           | `""`                        |
| `storegateway.ingress.enabled`                                   | Enable ingress controller resource                                                                                                       | `false`                     |
| `storegateway.ingress.certManager`                               | Set this to true in order to add the corresponding annotations for cert-manager                                                          | `false`                     |
| `storegateway.ingress.hostname`                                  | Default host for the ingress resource                                                                                                    | `thanos-storegateway.local` |
| `storegateway.ingress.ingressClassName`                          | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                            | `""`                        |
| `storegateway.ingress.annotations`                               | Ingress annotations                                                                                                                      | `{}`                        |
| `storegateway.ingress.extraHosts`                                | The list of additional hostnames to be covered with this ingress record.                                                                 | `[]`                        |
| `storegateway.ingress.extraTls`                                  | The tls configuration for additional hostnames to be covered with this ingress record.                                                   | `[]`                        |
| `storegateway.ingress.secrets`                                   | If you're providing your own certificates, please use this to add the certificates as secrets                                            | `[]`                        |
| `storegateway.ingress.tls`                                       | Create ingress TLS section                                                                                                               | `false`                     |
| `storegateway.ingress.apiVersion`                                | Force Ingress API version (automatically detected if not set)                                                                            | `""`                        |
| `storegateway.ingress.path`                                      | Ingress path                                                                                                                             | `/`                         |
| `storegateway.ingress.pathType`                                  | Ingress path type                                                                                                                        | `ImplementationSpecific`    |
| `storegateway.sharded.enabled`                                   | Enable sharding for Thanos Store Gateway                                                                                                 | `false`                     |
| `storegateway.sharded.hashPartitioning.shards`                   | Setting hashPartitioning will create multiple store statefulsets based on the number of shards specified using the hashmod of the blocks | `""`                        |
| `storegateway.sharded.timePartitioning`                          | Setting time timePartitioning will create multiple store deployments based on the number of partitions                                   | `[]`                        |
| `storegateway.sharded.service.clusterIPs`                        | Array of cluster IPs for each Store Gateway service. Length must be the same as the number of shards                                     | `[]`                        |
| `storegateway.sharded.service.loadBalancerIPs`                   | Array of load balancer IPs for each Store Gateway service. Length must be the same as the number of shards                               | `[]`                        |
| `storegateway.sharded.service.http.nodePorts`                    | Array of http node ports used for Store Gateway service. Length must be the same as the number of shards                                 | `[]`                        |
| `storegateway.sharded.service.grpc.nodePorts`                    | Array of grpc node ports used for Store Gateway service. Length must be the same as the number of shards                                 | `[]`                        |


### Thanos Ruler parameters

| Name                                                      | Description                                                                                                  | Value                    |
| --------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ | ------------------------ |
| `ruler.enabled`                                           | Enable/disable Thanos Ruler component                                                                        | `false`                  |
| `ruler.logLevel`                                          | Thanos Ruler log level                                                                                       | `info`                   |
| `ruler.logFormat`                                         | Thanos Ruler log format                                                                                      | `logfmt`                 |
| `ruler.replicaLabel`                                      | Label to treat as a replica indicator along which data is deduplicated                                       | `replica`                |
| `ruler.serviceAccount.annotations`                        | Annotations for Thanos Ruler Service Account                                                                 | `{}`                     |
| `ruler.serviceAccount.existingServiceAccount`             | Name for an existing Thanos Ruler Service Account                                                            | `""`                     |
| `ruler.hostAliases`                                       | Add deployment host aliases                                                                                  | `[]`                     |
| `ruler.dnsDiscovery.enabled`                              | Dynamically configure Query APIs using DNS discovery                                                         | `true`                   |
| `ruler.alertmanagers`                                     | Alermanager URLs array                                                                                       | `[]`                     |
| `ruler.alertmanagersConfig`                               | Alertmanagers Configuration                                                                                  | `""`                     |
| `ruler.evalInterval`                                      | The default evaluation interval to use                                                                       | `1m`                     |
| `ruler.clusterName`                                       | Used to set the 'ruler_cluster' label                                                                        | `""`                     |
| `ruler.extraContainers`                                   | Extra containers running as sidecars to Thanos Ruler container                                               | `[]`                     |
| `ruler.extraEnv`                                          | Extra environment variables for Thanos Ruler container                                                       | `[]`                     |
| `ruler.extraVolumes`                                      | Extra volumes to add to Thanos Ruler                                                                         | `[]`                     |
| `ruler.extraVolumeMounts`                                 | Extra volume mounts to add to the ruler container                                                            | `[]`                     |
| `ruler.extraFlags`                                        | Extra Flags to passed to Thanos Ruler                                                                        | `[]`                     |
| `ruler.config`                                            | Ruler configuration                                                                                          | `""`                     |
| `ruler.existingConfigmap`                                 | Name of existing ConfigMap with Ruler configuration                                                          | `""`                     |
| `ruler.replicaCount`                                      | Number of Thanos Ruler replicas to deploy                                                                    | `1`                      |
| `ruler.updateStrategyType`                                | Statefulset Update Strategy Type                                                                             | `RollingUpdate`          |
| `ruler.podManagementPolicy`                               | Statefulset Pod Management Policy Type                                                                       | `OrderedReady`           |
| `ruler.podAffinityPreset`                                 | Thanos Ruler pod affinity preset                                                                             | `""`                     |
| `ruler.podAntiAffinityPreset`                             | Thanos Ruler pod anti-affinity preset. Ignored if `ruler.affinity` is set. Allowed values: `soft` or `hard`  | `soft`                   |
| `ruler.nodeAffinityPreset.type`                           | Thanos Ruler node affinity preset type. Ignored if `ruler.affinity` is set. Allowed values: `soft` or `hard` | `""`                     |
| `ruler.nodeAffinityPreset.key`                            | Thanos Ruler node label key to match Ignored if `ruler.affinity` is set.                                     | `""`                     |
| `ruler.nodeAffinityPreset.values`                         | Thanos Ruler node label values to match. Ignored if `ruler.affinity` is set.                                 | `[]`                     |
| `ruler.affinity`                                          | Thanos Ruler affinity for pod assignment                                                                     | `{}`                     |
| `ruler.nodeSelector`                                      | Thanos Ruler node labels for pod assignment                                                                  | `{}`                     |
| `ruler.tolerations`                                       | Thanos Ruler tolerations for pod assignment                                                                  | `[]`                     |
| `ruler.podLabels`                                         | Thanos Ruler pod labels                                                                                      | `{}`                     |
| `ruler.podAnnotations`                                    | Annotations for Thanos Ruler pods                                                                            | `{}`                     |
| `ruler.priorityClassName`                                 | Controller priorityClassName                                                                                 | `""`                     |
| `ruler.podSecurityContext.enabled`                        | Enable security context for the Thanos Ruler pod                                                             | `true`                   |
| `ruler.podSecurityContext.fsGroup`                        | Group ID for the filesystem used by Ruler container                                                          | `1001`                   |
| `ruler.podSecurityContext.runAsUser`                      | User ID for the service user running the Ruler pod                                                           | `1001`                   |
| `ruler.containerSecurityContext.enabled`                  | Enable container security context for Ruler container                                                        | `true`                   |
| `ruler.containerSecurityContext.runAsNonRoot`             | Force the container Ruler to run as a non root user                                                          | `true`                   |
| `ruler.containerSecurityContext.allowPrivilegeEscalation` | Switch privilegeEscalation possiblity on or off for Ruler                                                    | `false`                  |
| `ruler.containerSecurityContext.readOnlyRootFilesystem`   | mount / (root) as a readonly filesystem of Ruler container                                                   | `false`                  |
| `ruler.resources.limits`                                  | The resources limits for the Thanos Ruler container                                                          | `{}`                     |
| `ruler.resources.requests`                                | The requested resources for the Thanos Ruler container                                                       | `{}`                     |
| `ruler.livenessProbe.enabled`                             | Enable livenessProbe                                                                                         | `true`                   |
| `ruler.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                      | `30`                     |
| `ruler.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                             | `10`                     |
| `ruler.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                            | `30`                     |
| `ruler.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                          | `6`                      |
| `ruler.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                          | `1`                      |
| `ruler.readinessProbe.enabled`                            | Enable readinessProbe                                                                                        | `true`                   |
| `ruler.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                     | `30`                     |
| `ruler.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                            | `10`                     |
| `ruler.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                           | `30`                     |
| `ruler.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                         | `6`                      |
| `ruler.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                         | `1`                      |
| `ruler.service.type`                                      | Kubernetes service type                                                                                      | `ClusterIP`              |
| `ruler.service.clusterIP`                                 | Thanos Ruler service clusterIP IP                                                                            | `""`                     |
| `ruler.service.http.port`                                 | Service HTTP port                                                                                            | `9090`                   |
| `ruler.service.http.nodePort`                             | Service HTTP node port                                                                                       | `""`                     |
| `ruler.service.targetPort`                                | Service targetPort override                                                                                  | `http`                   |
| `ruler.service.grpc.port`                                 | Service GRPC port                                                                                            | `10901`                  |
| `ruler.service.grpc.nodePort`                             | Service GRPC node port                                                                                       | `""`                     |
| `ruler.service.loadBalancerIP`                            | Load balancer IP if service type is `LoadBalancer`                                                           | `""`                     |
| `ruler.service.loadBalancerSourceRanges`                  | Address that are allowed when service is LoadBalancer                                                        | `[]`                     |
| `ruler.service.externalTrafficPolicy`                     | Thanos Ruler service externalTrafficPolicy                                                                   | `Cluster`                |
| `ruler.service.annotations`                               | Annotations for Thanos Ruler service                                                                         | `{}`                     |
| `ruler.service.labelSelectorsOverride`                    | Selector for Thanos query service                                                                            | `{}`                     |
| `ruler.service.additionalHeadless`                        | Additional Headless service                                                                                  | `false`                  |
| `ruler.persistence.enabled`                               | Enable data persistence                                                                                      | `true`                   |
| `ruler.persistence.existingClaim`                         | Use a existing PVC which must be created manually before bound                                               | `""`                     |
| `ruler.persistence.storageClass`                          | Specify the `storageClass` used to provision the volume                                                      | `""`                     |
| `ruler.persistence.accessModes`                           | Access modes of data volume                                                                                  | `["ReadWriteOnce"]`      |
| `ruler.persistence.size`                                  | Size of data volume                                                                                          | `8Gi`                    |
| `ruler.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                              | `false`                  |
| `ruler.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                               | `1`                      |
| `ruler.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                               | `""`                     |
| `ruler.ingress.enabled`                                   | Enable ingress controller resource                                                                           | `false`                  |
| `ruler.ingress.certManager`                               | Add annotations for cert-manager                                                                             | `false`                  |
| `ruler.ingress.hostname`                                  | Default host for the ingress resource                                                                        | `thanos-ruler.local`     |
| `ruler.ingress.ingressClassName`                          | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                | `""`                     |
| `ruler.ingress.annotations`                               | Ingress annotations                                                                                          | `{}`                     |
| `ruler.ingress.extraHosts`                                | The list of additional hostnames to be covered with this ingress record.                                     | `[]`                     |
| `ruler.ingress.extraTls`                                  | The tls configuration for additional hostnames to be covered with this ingress record.                       | `[]`                     |
| `ruler.ingress.secrets`                                   | If you're providing your own certificates, please use this to add the certificates as secrets                | `[]`                     |
| `ruler.ingress.apiVersion`                                | Force Ingress API version (automatically detected if not set)                                                | `""`                     |
| `ruler.ingress.path`                                      | Ingress path                                                                                                 | `/`                      |
| `ruler.ingress.pathType`                                  | Ingress path type                                                                                            | `ImplementationSpecific` |


### Thanos Receive parameters

| Name                                                        | Description                                                                                                                        | Value                    |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `receive.enabled`                                           | Enable/disable Thanos Receive component                                                                                            | `false`                  |
| `receive.mode`                                              | Mode to run receiver in. Valid options are "standalone" or "dual-mode"                                                             | `standalone`             |
| `receive.distributor.resources.limits`                      | The resources limits for the Thanos Receive container                                                                              | `{}`                     |
| `receive.distributor.resources.requests`                    | The requested resources for the Thanos Receive container                                                                           | `{}`                     |
| `receive.distributor.extraContainers`                       | Extra containers running as sidecars to Thanos Receive Distributor container                                                       | `[]`                     |
| `receive.distributor.extraEnv`                              | Extra environment variables for Thanos Receive Distributor container                                                               | `[]`                     |
| `receive.distributor.extraVolumes`                          | Extra volumes to add to Thanos Receive Distributor                                                                                 | `[]`                     |
| `receive.distributor.extraVolumeMounts`                     | Extra volume mounts to add to the receive distributor container                                                                    | `[]`                     |
| `receive.distributor.extraFlags`                            | Extra Flags to passed to Thanos Receive Distributor                                                                                | `[]`                     |
| `receive.distributor.replicaCount`                          | Number of Thanos Receive Distributor replicas to deploy                                                                            | `1`                      |
| `receive.distributor.strategyType`                          | StrategyType, can be set to RollingUpdate or Recreate by default.                                                                  | `RollingUpdate`          |
| `receive.distributor.affinity`                              | Thanos Receive Distributor affinity for pod assignment                                                                             | `{}`                     |
| `receive.distributor.nodeSelector`                          | Thanos Receive Distributor node labels for pod assignment                                                                          | `{}`                     |
| `receive.distributor.tolerations`                           | Thanos Receive Distributor tolerations for pod assignment                                                                          | `[]`                     |
| `receive.logLevel`                                          | Thanos Receive log level                                                                                                           | `info`                   |
| `receive.logFormat`                                         | Thanos Receive log format                                                                                                          | `logfmt`                 |
| `receive.tsdbRetention`                                     | Thanos Receive TSDB retention period                                                                                               | `15d`                    |
| `receive.replicationFactor`                                 | Thanos Receive replication-factor                                                                                                  | `1`                      |
| `receive.replicaLabel`                                      | Label to treat as a replica indicator along which data is deduplicated                                                             | `replica`                |
| `receive.serviceAccount.annotations`                        | Annotations for Thanos Receive Service Account                                                                                     | `{}`                     |
| `receive.serviceAccount.existingServiceAccount`             | Name for an existing Thanos Receive Service Account                                                                                | `""`                     |
| `receive.hostAliases`                                       | Deployment pod host aliases                                                                                                        | `[]`                     |
| `receive.config`                                            | Receive Hashring configuration                                                                                                     | `[]`                     |
| `receive.extraContainers`                                   | Extra containers running as sidecars to Thanos Receive container                                                                   | `[]`                     |
| `receive.extraEnv`                                          | Extra environment variables for Thanos Receive container                                                                           | `[]`                     |
| `receive.extraVolumes`                                      | Extra volumes to add to Thanos Receive                                                                                             | `[]`                     |
| `receive.extraVolumeMounts`                                 | Extra volume mounts to add to the receive container                                                                                | `[]`                     |
| `receive.extraFlags`                                        | Extra Flags to passed to Thanos Receive                                                                                            | `[]`                     |
| `receive.updateStrategyType`                                | Statefulset Update Strategy Type, can be set to RollingUpdate or OnDelete by default                                               | `RollingUpdate`          |
| `receive.replicaCount`                                      | Number of Thanos Receive replicas to deploy                                                                                        | `1`                      |
| `receive.strategyType`                                      | StrategyType, can be set to RollingUpdate or Recreate by default.                                                                  | `RollingUpdate`          |
| `receive.podAffinityPreset`                                 | Thanos Receive pod affinity preset                                                                                                 | `""`                     |
| `receive.podAntiAffinityPreset`                             | Thanos Receive pod anti-affinity preset. Ignored if `ruler.affinity` is set. Allowed values: `soft` or `hard`                      | `soft`                   |
| `receive.nodeAffinityPreset.type`                           | Thanos Receive node affinity preset type. Ignored if `ruler.affinity` is set. Allowed values: `soft` or `hard`                     | `""`                     |
| `receive.nodeAffinityPreset.key`                            | Thanos Receive node label key to match Ignored if `ruler.affinity` is set.                                                         | `""`                     |
| `receive.nodeAffinityPreset.values`                         | Thanos Receive node label values to match. Ignored if `ruler.affinity` is set.                                                     | `[]`                     |
| `receive.affinity`                                          | Thanos Receive affinity for pod assignment                                                                                         | `{}`                     |
| `receive.nodeSelector`                                      | Thanos Receive node labels for pod assignment                                                                                      | `{}`                     |
| `receive.tolerations`                                       | Thanos Receive tolerations for pod assignment                                                                                      | `[]`                     |
| `receive.podLabels`                                         | Thanos Receive pod labels                                                                                                          | `{}`                     |
| `receive.podAnnotations`                                    | Annotations for Thanos Ruler pods                                                                                                  | `{}`                     |
| `receive.priorityClassName`                                 | Controller priorityClassName                                                                                                       | `""`                     |
| `receive.rbac.create`                                       | Create ClusterRole and ClusterRolebing for the Service account                                                                     | `false`                  |
| `receive.pspEnabled`                                        | Create PodSecurity Policy                                                                                                          | `false`                  |
| `receive.resources.limits`                                  | The resources limits for the Thanos Receive container                                                                              | `{}`                     |
| `receive.resources.requests`                                | The requested resources for the Thanos Receive container                                                                           | `{}`                     |
| `receive.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                               | `true`                   |
| `receive.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                            | `30`                     |
| `receive.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                   | `10`                     |
| `receive.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                  | `30`                     |
| `receive.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                | `6`                      |
| `receive.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                | `1`                      |
| `receive.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                              | `true`                   |
| `receive.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                           | `30`                     |
| `receive.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                  | `10`                     |
| `receive.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                 | `30`                     |
| `receive.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                               | `6`                      |
| `receive.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                               | `1`                      |
| `receive.podSecurityContext.enabled`                        | Enable security context for the Thanos Receive pod                                                                                 | `true`                   |
| `receive.podSecurityContext.fsGroup`                        | Group ID for the filesystem used by Receive container                                                                              | `1001`                   |
| `receive.podSecurityContext.runAsUser`                      | User ID for the service user running the Receive pod                                                                               | `1001`                   |
| `receive.containerSecurityContext.enabled`                  | Enable container security context for Receive container                                                                            | `true`                   |
| `receive.containerSecurityContext.runAsNonRoot`             | Force the container Receive to run as a non root user                                                                              | `true`                   |
| `receive.containerSecurityContext.allowPrivilegeEscalation` | Switch privilegeEscalation possiblity on or off for Receive                                                                        | `false`                  |
| `receive.containerSecurityContext.readOnlyRootFilesystem`   | mount / (root) as a readonly filesystem of Receive container                                                                       | `false`                  |
| `receive.grpc.gracePeriod`                                  | Time to wait after an interrupt received for GRPC Server.                                                                          | `2m`                     |
| `receive.grpc.server.secure`                                | enable TLS for GRPC server                                                                                                         | `false`                  |
| `receive.grpc.server.cert`                                  | TLS Certificate for gRPC server, leave blank to disable TLS                                                                        | `""`                     |
| `receive.grpc.server.key`                                   | TLS Key for the gRPC server, leave blank to disable TLS                                                                            | `""`                     |
| `receive.grpc.server.ca`                                    | TLS CA to verify clients against. If no client CA is specified, there is no client verification on server side. (tls.NoClientCert) | `""`                     |
| `receive.service.type`                                      | Kubernetes service type                                                                                                            | `ClusterIP`              |
| `receive.service.clusterIP`                                 | Thanos Ruler service clusterIP IP                                                                                                  | `""`                     |
| `receive.service.http.port`                                 | Service HTTP port                                                                                                                  | `10902`                  |
| `receive.service.http.nodePort`                             | Service HTTP node port                                                                                                             | `""`                     |
| `receive.service.targetPort`                                | Service targetPort override                                                                                                        | `http`                   |
| `receive.service.grpc.port`                                 | Service GRPC port                                                                                                                  | `10901`                  |
| `receive.service.grpc.nodePort`                             | Service GRPC node port                                                                                                             | `""`                     |
| `receive.service.remoteWrite.port`                          | Service remote write port                                                                                                          | `19291`                  |
| `receive.service.remoteWrite.nodePort`                      | Service remote write node port                                                                                                     | `""`                     |
| `receive.service.loadBalancerIP`                            | Load balancer IP if service type is `LoadBalancer`                                                                                 | `""`                     |
| `receive.service.loadBalancerSourceRanges`                  | Addresses that are allowed when service is LoadBalancer                                                                            | `[]`                     |
| `receive.service.externalTrafficPolicy`                     | Thanos Ruler service externalTrafficPolicy                                                                                         | `Cluster`                |
| `receive.service.annotations`                               | Annotations for Thanos Receive service                                                                                             | `{}`                     |
| `receive.service.labelSelectorsOverride`                    | Selector for Thanos receive service                                                                                                | `{}`                     |
| `receive.service.additionalHeadless`                        | Additional Headless service                                                                                                        | `false`                  |
| `receive.autoscaling.enabled`                               | Enable autoscaling for Thanos Receive                                                                                              | `false`                  |
| `receive.autoscaling.minReplicas`                           | Minimum number of Thanos Receive replicas                                                                                          | `""`                     |
| `receive.autoscaling.maxReplicas`                           | Maximum number of Thanos Receive replicas                                                                                          | `""`                     |
| `receive.autoscaling.targetCPU`                             | Target CPU utilization percentage                                                                                                  | `""`                     |
| `receive.autoscaling.targetMemory`                          | Target Memory utilization percentage                                                                                               | `""`                     |
| `receive.persistence.enabled`                               | Enable data persistence                                                                                                            | `true`                   |
| `receive.persistence.existingClaim`                         | Use a existing PVC which must be created manually before bound                                                                     | `""`                     |
| `receive.persistence.storageClass`                          | Specify the `storageClass` used to provision the volume                                                                            | `""`                     |
| `receive.persistence.accessModes`                           | Access modes of data volume                                                                                                        | `["ReadWriteOnce"]`      |
| `receive.persistence.size`                                  | Size of data volume                                                                                                                | `8Gi`                    |
| `receive.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                    | `false`                  |
| `receive.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                     | `1`                      |
| `receive.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable                                                                     | `""`                     |
| `receive.ingress.enabled`                                   | Set to true to enable ingress record generation                                                                                    | `false`                  |
| `receive.ingress.certManager`                               | Set this to true in order to add the corresponding annotations for cert-manager                                                    | `false`                  |
| `receive.ingress.hostname`                                  | When the ingress is enabled, a host pointing to this will be created                                                               | `thanos-receive.local`   |
| `receive.ingress.ingressClassName`                          | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                      | `""`                     |
| `receive.ingress.annotations`                               | Ingress annotations done as key:value pairs                                                                                        | `{}`                     |
| `receive.ingress.extraHosts`                                | The list of additional hostnames to be covered with this ingress record.                                                           | `[]`                     |
| `receive.ingress.extraTls`                                  | The tls configuration for additional hostnames to be covered with this ingress record.                                             | `[]`                     |
| `receive.ingress.secrets`                                   | If you're providing your own certificates, please use this to add the certificates as secrets                                      | `[]`                     |
| `receive.ingress.tls`                                       | When specifying cert-manager.io/cluster-issuer: nameOfClusterIssuer annotation, enable tls for ingress                             | `false`                  |
| `receive.ingress.apiVersion`                                | Override API Version (automatically detected if not set)                                                                           | `""`                     |
| `receive.ingress.path`                                      | Ingress Path                                                                                                                       | `/`                      |
| `receive.ingress.pathType`                                  | Ingress Path type                                                                                                                  | `ImplementationSpecific` |


### Metrics parameters

| Name                                      | Description                                                                                            | Value   |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------- |
| `metrics.enabled`                         | Enable the export of Prometheus metrics                                                                | `false` |
| `metrics.serviceMonitor.enabled`          | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) | `false` |
| `metrics.serviceMonitor.namespace`        | Namespace in which Prometheus is running                                                               | `""`    |
| `metrics.serviceMonitor.labels`           | Additional labels for ServiceMonitor object                                                            | `{}`    |
| `metrics.serviceMonitor.interval`         | Interval at which metrics should be scraped.                                                           | `""`    |
| `metrics.serviceMonitor.scrapeTimeout`    | Timeout after which the scrape is ended                                                                | `""`    |
| `metrics.prometheusRule.enabled`          | If `true`, creates a Prometheus Operator PrometheusRule (also requires `metrics.enabled` to be `true`) | `false` |
| `metrics.prometheusRule.namespace`        | Namespace in which the PrometheusRule CRD is created                                                   | `""`    |
| `metrics.prometheusRule.additionalLabels` | Additional labels for the prometheusRule                                                               | `{}`    |
| `metrics.prometheusRule.rules`            | Prometheus Rules for Thanos components                                                                 | `[]`    |


### Volume Permissions parameters

| Name                                  | Description                                                                                                          | Value                   |
| ------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`           | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`    | Init container volume-permissions image registry                                                                     | `docker.io`             |
| `volumePermissions.image.repository`  | Init container volume-permissions image repository                                                                   | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`         | Init container volume-permissions image tag                                                                          | `10-debian-10-r194`     |
| `volumePermissions.image.pullPolicy`  | Init container volume-permissions image pull policy                                                                  | `Always`                |
| `volumePermissions.image.pullSecrets` | Specify docker-registry secret names as an array                                                                     | `[]`                    |


### MinIO&reg; chart parameters

| Name                       | Description                                                               | Value    |
| -------------------------- | ------------------------------------------------------------------------- | -------- |
| `minio.enabled`            | Enable/disable MinIO&reg; chart installation                              | `false`  |
| `minio.accessKey.password` | MinIO&reg; Access Key                                                     | `""`     |
| `minio.secretKey.password` | MinIO&reg; Secret Key                                                     | `""`     |
| `minio.defaultBuckets`     | Comma, semi-colon or space separated list of MinIO&reg; buckets to create | `thanos` |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install my-release --set query.replicaCount=2 bitnami/thanos
```

The above command install Thanos chart with 2 Thanos Query replicas.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install my-release -f values.yaml bitnami/thanos
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Adding extra flags

In case you want to add extra flags to any Thanos component, you can use `XXX.extraFlags` parameter(s), where XXX is placeholder you need to replace with the actual component(s). For instance, to add extra flags to Thanos Store Gateway, use:

```yaml
storegateway:
  extraFlags:
    - --sync-block-duration=3m
    - --chunk-pool-size=2GB
```

This also works for multi-line flags. This can be useful when you want to configure caching for a particular component without using a configMap. For example, to configure the [query-range response cache of the Thanos Query Frontend](https://thanos.io/tip/components/query-frontend.md/#memcached), use:

```yaml
queryFrontend:
  extraFlags:
    - |
      --query-range.response-cache-config=
      type: MEMCACHED
      config:
        addresses:
          - <MEMCACHED_SERVER>:11211
        timeout: 500ms
        max_idle_connections: 100
        max_async_concurrency: 10
        max_async_buffer_size: 10000
        max_get_multi_concurrency: 100
        max_get_multi_batch_size: 0
        dns_provider_update_interval: 10s
        expiration: 24h
```

### Using custom Objstore configuration

This helm chart supports using custom Objstore configuration.

You can specify the Objstore configuration using the `objstoreConfig` parameter.

In addition, you can also set an external Secret with the configuration file. This is done by setting the `existingObjstoreSecret` parameter. Note that this will override the previous option. If needed you can also provide a custom Secret Key with `existingObjstoreSecretItems`, please be aware that the Path of your Secret should be `objstore.yml`.

### Using custom Query Service Discovery configuration

This helm chart supports using custom Service Discovery configuration for Query.

You can specify the Service Discovery configuration using the `query.sdConfig` parameter.

In addition, you can also set an external ConfigMap with the Service Discovery configuration file. This is done by setting the `query.existingSDConfigmap` parameter. Note that this will override the previous option.

### Using custom Ruler configuration

This helm chart supports using custom Ruler configuration.

You can specify the Ruler configuration using the `ruler.config` parameter.

In addition, you can also set an external ConfigMap with the configuration file. This is done by setting the `ruler.existingConfigmap` parameter. Note that this will override the previous option.

### Store time partitions

Thanos store supports partion based on time.

Setting time partitions will create N number of store statefulsets based on the number of items in the `timePartitioning` list. Each item must contain the min and max time for querying in the supported format (find more details at [Thanos documentation](https://thanos.io/tip/components/store.md/#time-based-partitioning)).

> Note: leaving the `timePartitioning` list empty (`[]`) will create a single store for all data.

For instance, to use 3 stores you can use a **values.yaml** like the one below:

```yaml
timePartitioning:
  # One store for data older than 6 weeks
  - min: ""
    max: -6w
  # One store for data newer than 6 weeks and older than 2 weeks
  - min: -6w
    max: -2w
  # One store for data newer than 2 weeks
  - min: -2w
    max: ""
```

### Integrate Thanos with Prometheus and Alertmanager

You can intregrate Thanos with Prometheus & Alertmanager using this chart and the [Bitnami kube-prometheus chart](https://github.com/bitnami/charts/tree/master/bitnami/kube-prometheus) following the steps below:

> Note: in this example we will use MinIO&reg; (subchart) as the Objstore. Every component will be deployed in the "monitoring" namespace.

- Create a **values.yaml** like the one below:

```yaml
objstoreConfig: |-
  type: s3
  config:
    bucket: thanos
    endpoint: {{ include "thanos.minio.fullname" . }}.monitoring.svc.cluster.local:9000
    access_key: minio
    secret_key: minio123
    insecure: true
query:
  dnsDiscovery:
    sidecarsService: kube-prometheus-prometheus-thanos
    sidecarsNamespace: monitoring
bucketweb:
  enabled: true
compactor:
  enabled: true
storegateway:
  enabled: true
ruler:
  enabled: true
  alertmanagers:
    - http://kube-prometheus-alertmanager.monitoring.svc.cluster.local:9093
  config: |-
    groups:
      - name: "metamonitoring"
        rules:
          - alert: "PrometheusDown"
            expr: absent(up{prometheus="monitoring/kube-prometheus"})
metrics:
  enabled: true
  serviceMonitor:
    enabled: true
minio:
  enabled: true
  accessKey:
    password: "minio"
  secretKey:
    password: "minio123"
  defaultBuckets: "thanos"
```

- Install Prometheus Operator and Thanos charts:

For Helm 3:

```bash
kubectl create namespace monitoring
helm install kube-prometheus \
    --set prometheus.thanos.create=true \
    --namespace monitoring \
    bitnami/kube-prometheus
helm install thanos \
    --values values.yaml \
    --namespace monitoring \
    bitnami/thanos
```

That's all! Now you have Thanos fully integrated with Prometheus and Alertmanager.

## Persistence

The data is persisted by default using PVC(s) on Thanos components. You can disable the persistence setting the `XXX.persistence.enabled` parameter(s) to `false`. A default `StorageClass` is needed in the Kubernetes cluster to dynamically provision the volumes. Specify another StorageClass in the `XXX.persistence.storageClass` parameter(s) or set `XXX.persistence.existingClaim` if you have already existing persistent volumes to use.

> Note: you need to substitute the XXX placeholders above with the actual component(s) you want to configure.

### Adjust permissions of persistent volume mountpoint

As the images run as non-root by default, it is necessary to adjust the ownership of the persistent volumes so that the containers can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volumes. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volumes before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `XXX.affinity` parameter(s). Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `XXX.podAffinityPreset`, `XXX.podAntiAffinityPreset`, or `XXX.nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 6.0.0

This major updates the MinIO&reg; subchart to its newest major, 8.0.0, which now has two separated services for MinIO&reg; Console and MinIO&reg; API. Check [MinIO&reg; Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/minio#to-800) for more information.

### To 5.4.0

This version introduces support for the receiver dual-mode implementation for Thanos [v0.22+](https://github.com/thanos-io/thanos/releases/tag/v0.22.0)

### To 5.3.0

This version introduces hash and time partitioning for the store gateway.

### To 5.0.0

This major update changes the `securityContext` interface in the `values.yaml` file.

Please note if you have changes in the `securityContext` fields those need to be migrated to `podSecurityContext`.

```diff
# ...
- securityContext:
+ podSecurityContext:
# ...
```

Other than that a new `securityContext` interface for containers got introduced `containerSecurityContext`. It's default is enabled so if you do not need it you need to opt out of it.

```diff
# ...
+ containerSecurityContext
+   enabled: true  # opt out by enabled: false
+   capabilities:
+     drop:
+     - ALL
+   runAsNonRoot: true
+   allowPrivilegeEscalation: false
+   readOnlyRootFilesystem: false
# ...
```

### To 4.0.0

This major updates the MinIO subchart to its newest major, 7.0.0, which removes previous configuration of `securityContext` and moves to `podSecurityContext` and `containerSecurityContext`.

### To 3.3.0

This version introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

### To 3.1.0

The querier component and its settings have been renamed to query. Configuration of the query component by using keys under `querier` in your `values.yaml` will continue to work. Support for keys under `querier` will be dropped in a future release.

```
querier.enabled                               -> query.enabled
querier.logLevel                              -> query.logLevel
querier.replicaLabel                          -> query.replicaLabel
querier.dnsDiscovery.enabled                  -> query.dnsDiscovery.enabled
querier.dnsDiscovery.sidecarsService          -> query.dnsDiscovery.sidecarsService
querier.dnsDiscovery.sidecarsNamespace        -> query.dnsDiscovery.sidecarsNamespace
querier.stores                                -> query.stores
querier.sdConfig                              -> query.sdConfig
querier.existingSDConfigmap                   -> query.existingSDConfigmap
querier.extraFlags                            -> query.extraFlags
querier.replicaCount                          -> query.replicaCount
querier.strategyType                          -> query.strategyType
querier.affinity                              -> query.affinity
querier.nodeSelector                          -> query.nodeSelector
querier.tolerations                           -> query.tolerations
querier.podLabels                             -> query.podLabels
querier.priorityClassName                     -> query.priorityClassName
querier.securityContext.enabled               -> query.securityContext.enabled
querier.securityContext.fsGroup               -> query.securityContext.fsGroup
querier.securityContext.runAsUser             -> query.securityContext.runAsUser
querier.resources.limits                      -> query.resources.limits
querier.resources.requests                    -> query.resources.requests
querier.podAnnotations                        -> query.podAnnotations
querier.livenessProbe                         -> query.livenessProbe
querier.readinessProbe                        -> query.readinessProbe
querier.grpcTLS.server.secure                 -> query.grpcTLS.server.secure
querier.grpcTLS.server.cert                   -> query.grpcTLS.server.cert
querier.grpcTLS.server.key                    -> query.grpcTLS.server.key
querier.grpcTLS.server.ca                     -> query.grpcTLS.server.ca
querier.grpcTLS.client.secure                 -> query.grpcTLS.client.secure
querier.grpcTLS.client.cert                   -> query.grpcTLS.client.cert
querier.grpcTLS.client.key                    -> query.grpcTLS.client.key
querier.grpcTLS.client.ca                     -> query.grpcTLS.client.ca
querier.grpcTLS.client.servername             -> query.grpcTLS.client.servername
querier.service.type                          -> query.service.type
querier.service.clusterIP                     -> query.service.clusterIP
querier.service.http.port                     -> query.service.http.port
querier.service.http.nodePort                 -> query.service.http.nodePort
querier.service.grpc.port                     -> query.service.grpc.port
querier.service.grpc.nodePort                 -> query.service.grpc.nodePort
querier.service.loadBalancerIP                -> query.service.loadBalancerIP
querier.service.loadBalancerSourceRanges      -> query.service.loadBalancerSourceRanges
querier.service.annotations                   -> query.service.annotations
querier.service.labelSelectorsOverride        -> query.service.labelSelectorsOverride
querier.serviceAccount.annotations            -> query.serviceAccount.annotations
querier.rbac.create                           -> query.rbac.create
querier.pspEnabled                            -> query.pspEnabled
querier.autoscaling.enabled                   -> query.autoscaling.enabled
querier.autoscaling.minReplicas               -> query.autoscaling.minReplicas
querier.autoscaling.maxReplicas               -> query.autoscaling.maxReplicas
querier.autoscaling.targetCPU                 -> query.autoscaling.targetCPU
querier.autoscaling.targetMemory              -> query.autoscaling.targetMemory
querier.pdb.create                            -> query.pdb.create
querier.pdb.minAvailable                      -> query.pdb.minAvailable
querier.pdb.maxUnavailable                    -> query.pdb.maxUnavailable
querier.ingress.enabled                       -> query.ingress.enabled
querier.ingress.certManager                   -> query.ingress.certManager
querier.ingress.hostname                      -> query.ingress.hostname
querier.ingress.annotations                   -> query.ingress.annotations
querier.ingress.tls                           -> query.ingress.tls
querier.ingress.extraHosts[0].name            -> query.ingress.extraHosts[0].name
querier.ingress.extraHosts[0].path            -> query.ingress.extraHosts[0].path
querier.ingress.extraTls[0].hosts[0]          -> query.ingress.extraTls[0].hosts[0]
querier.ingress.extraTls[0].secretName        -> query.ingress.extraTls[0].secretName
querier.ingress.secrets[0].name               -> query.ingress.secrets[0].name
querier.ingress.secrets[0].certificate        -> query.ingress.secrets[0].certificate
querier.ingress.secrets[0].key                -> query.ingress.secrets[0].key
querier.ingress.grpc.enabled                  -> query.ingress.grpc.enabled
querier.ingress.grpc.certManager              -> query.ingress.grpc.certManager
querier.ingress.grpc.hostname                 -> query.ingress.grpc.hostname
querier.ingress.grpc.annotations              -> query.ingress.grpc.annotations
querier.ingress.grpc.extraHosts[0].name       -> query.ingress.grpc.extraHosts[0].name
querier.ingress.grpc.extraHosts[0].path       -> query.ingress.grpc.extraHosts[0].path
querier.ingress.grpc.extraTls[0].hosts[0]     -> query.ingress.grpc.extraTls[0].hosts[0]
querier.ingress.grpc.extraTls[0].secretName   -> query.ingress.grpc.extraTls[0].secretName
querier.ingress.grpc.secrets[0].name          -> query.ingress.grpc.secrets[0].name
querier.ingress.grpc.secrets[0].certificate   -> query.ingress.grpc.secrets[0].certificate
querier.ingress.grpc.secrets[0].key           -> query.ingress.grpc.secrets[0].key
```

### To 3.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### To 2.4.0

The Ingress API object name for Querier changes from:

```yaml
{{ include "common.names.fullname" . }}
```

> **NOTE**: Which in most cases (depending on any set values in `fullnameOverride` or `nameOverride`) resolves to the used Helm release name (`.Release.Name`).

To:

```yaml
{{ include "common.names.fullname" . }}-querier
```

### To 2.0.0

The format of the chart's `extraFlags` option has been updated to be an array (instead of an object), to support passing multiple flags with the same name to Thanos.

Now you need to specify the flags in the following way in your values file (where component is one of `querier/bucketweb/compactor/storegateway/ruler`):

```yaml
component:
  ...
  extraFlags
    - --sync-block-duration=3m
    - --chunk-pool-size=2GB
```

To specify the values via CLI::

```console
--set 'component.extraFlags[0]=--sync-block-duration=3m' --set 'ruler.extraFlags[1]=--chunk-pool-size=2GB'
```

### To 1.0.0

If you are upgrading from a `<1.0.0` release you need to move your Querier Ingress information to the new values settings:
```
ingress.enabled -> querier.ingress.enabled
ingress.certManager -> querier.ingress.certManager
ingress.hostname -> querier.ingress.hostname
ingress.annotations -> querier.ingress.annotations
ingress.extraHosts[0].name -> querier.ingress.extraHosts[0].name
ingress.extraHosts[0].path -> querier.ingress.extraHosts[0].path
ingress.extraHosts[0].hosts[0] -> querier.ingress.extraHosts[0].hosts[0]
ingress.extraHosts[0].secretName -> querier.ingress.extraHosts[0].secretName
ingress.secrets[0].name -> querier.ingress.secrets[0].name
ingress.secrets[0].certificate -> querier.ingress.secrets[0].certificate
ingress.secrets[0].key -> querier.ingress.secrets[0].key

```
