# Discourse

[Discourse](https://www.discourse.org/) is an open source discussion platform. It can be used as a mailing list, discussion forum, long-form chat room, and more.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/discourse
```

## Introduction

This chart bootstraps a [Discourse](https://www.discourse.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages [Bitnami Postgresql](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) and [Bitnami Redis&trade;](https://github.com/bitnami/charts/tree/master/bitnami/redis) which are required as databases for the Discourse application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/discourse
```

The command deploys Discourse on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
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

| Name                | Description                                                                               | Value |
| ------------------- | ----------------------------------------------------------------------------------------- | ----- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                      | `""`  |
| `nameOverride`      | String to partially override discourse.fullname template (will maintain the release name) | `""`  |
| `fullnameOverride`  | String to fully override discourse.fullname template                                      | `""`  |
| `commonLabels`      | Labels to be added to all deployed resources                                              | `{}`  |
| `commonAnnotations` | Annotations to be added to all deployed resources                                         | `{}`  |


### Service parameters

| Name                               | Description                                                     | Value          |
| ---------------------------------- | --------------------------------------------------------------- | -------------- |
| `service.type`                     | Kubernetes Service type                                         | `LoadBalancer` |
| `service.port`                     | Service HTTP port                                               | `80`           |
| `service.nodePort`                 | Node Ports to expose                                            | `""`           |
| `service.loadBalancerIP`           | Use loadBalancerIP to request a specific static IP              | `""`           |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                            | `Cluster`      |
| `service.annotations`              | Service annotations                                             | `{}`           |
| `service.loadBalancerSourceRanges` | Limits which cidr blocks can connect to service's load balancer | `[]`           |
| `service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)  | `[]`           |
| `service.nodePorts.http`           | Kubernetes http node port                                       | `""`           |


### Discourse parameters

| Name                                           | Description                                                                                               | Value                |
| ---------------------------------------------- | --------------------------------------------------------------------------------------------------------- | -------------------- |
| `image.registry`                               | Discourse image registry                                                                                  | `docker.io`          |
| `image.repository`                             | Discourse image repository                                                                                | `bitnami/discourse`  |
| `image.tag`                                    | Discourse image tag                                                                                       | `2.7.8-debian-10-r0` |
| `image.pullPolicy`                             | Discourse image pull policy                                                                               | `IfNotPresent`       |
| `image.pullSecrets`                            | Discourse image pull secrets                                                                              | `[]`                 |
| `image.debug`                                  | Specify if debug logs should be enabled                                                                   | `false`              |
| `imagePullSecrets`                             | Specify docker-registry secret names as an array                                                          | `[]`                 |
| `discourse.host`                               | Discourse host to create application URLs (include the port if =/= 80)                                    | `""`                 |
| `discourse.siteName`                           | Discourse site name                                                                                       | `My Site!`           |
| `discourse.username`                           | Admin user of the application                                                                             | `user`               |
| `discourse.password`                           | password. WARNING: Minimum length of 10 characters                                                        | `""`                 |
| `discourse.existingSecret`                     | Name of an existing secret containing the password (ignores previous password)                            | `""`                 |
| `discourse.email`                              | Admin user email of the application                                                                       | `user@example.com`   |
| `discourse.command`                            | Custom command to override image cmd                                                                      | `[]`                 |
| `discourse.args`                               | Custom args for the custom command                                                                        | `[]`                 |
| `discourse.containerSecurityContext`           | Container security context specification                                                                  | `{}`                 |
| `discourse.resources.limits`                   | The resources limits for the container                                                                    | `{}`                 |
| `discourse.resources.requests`                 | The requested resources for the container                                                                 | `{}`                 |
| `discourse.livenessProbe.enabled`              | Enable/disable livenessProbe                                                                              | `true`               |
| `discourse.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                                  | `500`                |
| `discourse.livenessProbe.periodSeconds`        | How often to perform the probe                                                                            | `10`                 |
| `discourse.livenessProbe.timeoutSeconds`       | When the probe times out                                                                                  | `5`                  |
| `discourse.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe                                                                | `6`                  |
| `discourse.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe                                                               | `1`                  |
| `discourse.readinessProbe.enabled`             | Enable/disable readinessProbe                                                                             | `true`               |
| `discourse.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                                                                 | `30`                 |
| `discourse.readinessProbe.periodSeconds`       | How often to perform the probe                                                                            | `10`                 |
| `discourse.readinessProbe.timeoutSeconds`      | When the probe times out                                                                                  | `5`                  |
| `discourse.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe                                                                | `6`                  |
| `discourse.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe                                                               | `1`                  |
| `discourse.customLivenessProbe`                | Custom liveness probe to execute (when the main one is disabled)                                          | `{}`                 |
| `discourse.customReadinessProbe`               | Custom readiness probe to execute (when the main one is disabled)                                         | `{}`                 |
| `discourse.smtp.enabled`                       | Enable/disable SMTP                                                                                       | `false`              |
| `discourse.smtp.host`                          | SMTP host name                                                                                            | `""`                 |
| `discourse.smtp.port`                          | SMTP port number                                                                                          | `""`                 |
| `discourse.smtp.user`                          | SMTP account user name                                                                                    | `""`                 |
| `discourse.smtp.password`                      | SMTP account password                                                                                     | `""`                 |
| `discourse.smtp.protocol`                      | SMTP protocol (Allowed values: tls, ssl)                                                                  | `""`                 |
| `discourse.smtp.auth`                          | SMTP authentication method                                                                                | `""`                 |
| `discourse.smtp.existingSecret`                | Name of an existing Kubernetes secret. The secret must have the following key configured: `smtp-password` | `""`                 |
| `discourse.extraEnvVars`                       | An array to add extra env vars                                                                            | `[]`                 |
| `discourse.extraEnvVarsCM`                     | Array to add extra configmaps                                                                             | `[]`                 |
| `discourse.extraEnvVarsSecret`                 | Array to add extra environment variables from a secret                                                    | `""`                 |
| `discourse.extraVolumeMounts`                  | Additional volume mounts (used along with `extraVolumes`)                                                 | `[]`                 |
| `discourse.skipInstall`                        | Do not run the Discourse installation wizard                                                              | `false`              |
| `replicaCount`                                 | Number of Discourse & Sidekiq replicas                                                                    | `1`                  |
| `extraVolumes`                                 | Array of extra volumes to be added deployment. Requires setting `extraVolumeMounts`                       | `[]`                 |
| `sidecars`                                     | Attach additional sidecar containers to the pod                                                           | `[]`                 |
| `initContainers`                               | Additional init containers to add to the pods                                                             | `[]`                 |
| `serviceAccount.create`                        | Whether the service account should be created                                                             | `false`              |
| `serviceAccount.annotations`                   | Annotations to add to the service account                                                                 | `{}`                 |
| `serviceAccount.name`                          | Name to be used for the service account                                                                   | `""`                 |
| `podSecurityContext`                           | Pod security context specification                                                                        | `{}`                 |
| `hostAliases`                                  | Add deployment host aliases                                                                               | `[]`                 |
| `persistence.enabled`                          | Whether to enable persistence based on Persistent Volume Claims                                           | `true`               |
| `persistence.storageClass`                     | discourse & sidekiq data Persistent Volume Storage Class                                                  | `""`                 |
| `persistence.existingClaim`                    | Use a existing PVC which must be created manually before bound                                            | `""`                 |
| `persistence.accessMode`                       | PVC Access Mode (RWO, ROX, RWX)                                                                           | `ReadWriteOnce`      |
| `persistence.size`                             | Size of the PVC to request                                                                                | `10Gi`               |
| `persistence.selector`                         | Selector to match an existing Persistent Volume (this value is evaluated as a template)                   | `{}`                 |
| `updateStrategy.type`                          | Update strategy type. Only really applicable for deployments with RWO PVs attached                        | `RollingUpdate`      |
| `podAnnotations`                               | Additional pod annotations                                                                                | `{}`                 |
| `podLabels`                                    | Additional pod labels                                                                                     | `{}`                 |
| `podAffinityPreset`                            | Pod affinity preset. Allowed values: soft, hard                                                           | `""`                 |
| `podAntiAffinityPreset`                        | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                  | `soft`               |
| `nodeAffinityPreset.type`                      | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                 | `""`                 |
| `nodeAffinityPreset.key`                       | Node label key to match Ignored if `affinity` is set.                                                     | `""`                 |
| `nodeAffinityPreset.values`                    | Node label values to match. Ignored if `affinity` is set.                                                 | `[]`                 |
| `affinity`                                     | Affinity for pod assignment                                                                               | `{}`                 |
| `nodeSelector`                                 | Node labels for pod assignment.                                                                           | `{}`                 |
| `tolerations`                                  | Tolerations for pod assignment.                                                                           | `[]`                 |


### Sidekiq parameters

| Name                                         | Description                                                       | Value                                               |
| -------------------------------------------- | ----------------------------------------------------------------- | --------------------------------------------------- |
| `sidekiq.containerSecurityContext`           | Container security context specification                          | `{}`                                                |
| `sidekiq.command`                            | Custom command to override image cmd (evaluated as a template)    | `["/opt/bitnami/scripts/discourse/entrypoint.sh"]`  |
| `sidekiq.args`                               | Custom args for the custom command (evaluated as a template)      | `["/opt/bitnami/scripts/discourse-sidekiq/run.sh"]` |
| `sidekiq.resources`                          | Sidekiq container resource requests and limits                    | `{}`                                                |
| `sidekiq.livenessProbe.enabled`              | Enable/disable livenessProbe                                      | `true`                                              |
| `sidekiq.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                          | `500`                                               |
| `sidekiq.livenessProbe.periodSeconds`        | How often to perform the probe                                    | `10`                                                |
| `sidekiq.livenessProbe.timeoutSeconds`       | When the probe times out                                          | `5`                                                 |
| `sidekiq.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe                        | `6`                                                 |
| `sidekiq.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe                       | `1`                                                 |
| `sidekiq.readinessProbe.enabled`             | Enable/disable readinessProbe                                     | `true`                                              |
| `sidekiq.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                         | `30`                                                |
| `sidekiq.readinessProbe.periodSeconds`       | How often to perform the probe                                    | `10`                                                |
| `sidekiq.readinessProbe.timeoutSeconds`      | When the probe times out                                          | `5`                                                 |
| `sidekiq.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe                        | `6`                                                 |
| `sidekiq.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe                       | `1`                                                 |
| `sidekiq.customLivenessProbe`                | Custom liveness probe to execute (when the main one is disabled)  | `{}`                                                |
| `sidekiq.customReadinessProbe`               | Custom readiness probe to execute (when the main one is disabled) | `{}`                                                |
| `sidekiq.extraEnvVars`                       | An array to add extra env vars                                    | `[]`                                                |
| `sidekiq.extraEnvVarsCM`                     | Array to add extra configmaps                                     | `[]`                                                |
| `sidekiq.extraEnvVarsSecret`                 | Name of the secret that holds extra env vars                      | `""`                                                |
| `sidekiq.extraVolumeMounts`                  | Additional volume mounts                                          | `[]`                                                |


### Volume Permissions parameters

| Name                                   | Description                                                                                                                                               | Value   |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `volumePermissions.enabled`            | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false` |
| `volumePermissions.resources.limits`   | The resources limits for the init container                                                                                                               | `{}`    |
| `volumePermissions.resources.requests` | The requested resources for the init container                                                                                                            | `{}`    |


### Ingress parameters

| Name                  | Description                                                                                   | Value                    |
| --------------------- | --------------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.enabled`     | Enable ingress controller resource                                                            | `false`                  |
| `ingress.certManager` | Add annotations for cert-manager                                                              | `false`                  |
| `ingress.hostname`    | Default host for the ingress resource                                                         | `discourse.local`        |
| `ingress.apiVersion`  | Force Ingress API version (automatically detected if not set)                                 | `""`                     |
| `ingress.path`        | Ingress path                                                                                  | `/`                      |
| `ingress.pathType`    | Ingress path type                                                                             | `ImplementationSpecific` |
| `ingress.annotations` | Ingress annotations done as key:value pairs                                                   | `{}`                     |
| `ingress.tls`         | Enable TLS configuration for the hostname defined at ingress.hostname parameter               | `false`                  |
| `ingress.extraHosts`  | The list of additional hostnames to be covered with this ingress record.                      | `[]`                     |
| `ingress.extraTls`    | The tls configuration for additional hostnames to be covered with this ingress record.        | `[]`                     |
| `ingress.secrets`     | If you're providing your own certificates, please use this to add the certificates as secrets | `[]`                     |


### Database parameters

| Name                                          | Description                                                                                        | Value                 |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------- | --------------------- |
| `postgresql.enabled`                          | Deploy PostgreSQL container(s)                                                                     | `true`                |
| `postgresql.postgresqlUsername`               | PostgreSQL user to create (used by Discourse). Has superuser privileges if username is `postgres`. | `bn_discourse`        |
| `postgresql.postgresqlPassword`               | PostgreSQL password                                                                                | `""`                  |
| `postgresql.postgresqlPostgresPassword`       | PostgreSQL admin password (used when `postgresqlUsername` is not `postgres`)                       | `bitnami`             |
| `postgresql.existingSecret`                   | Name of existing secret object                                                                     | `""`                  |
| `postgresql.postgresqlDatabase`               | Name of the database to create                                                                     | `bitnami_application` |
| `postgresql.persistence.enabled`              | Enable database persistence using PVC                                                              | `true`                |
| `externalDatabase.host`                       | Host of the external database                                                                      | `""`                  |
| `externalDatabase.port`                       | Database port number (when using an external db)                                                   | `5432`                |
| `externalDatabase.user`                       | Non-root PostgreSQL username (when using an external db)                                           | `bn_discourse`        |
| `externalDatabase.password`                   | Password for the above username (when using an external db)                                        | `""`                  |
| `externalDatabase.create`                     | PostgreSQL create user/database                                                                    | `true`                |
| `externalDatabase.postgresqlPostgresUser`     | PostgreSQL admin user, used during the installation stage (when using an external db)              | `""`                  |
| `externalDatabase.postgresqlPostgresPassword` | PostgreSQL admin password used in the installation stage (when using an external db)               | `""`                  |
| `externalDatabase.existingSecret`             | Name of existing secret object                                                                     | `""`                  |
| `externalDatabase.database`                   | Name of the existing database (when using an external db)                                          | `bitnami_application` |


### Redis&trade; parameters

| Name                                      | Description                                                                                                                                                               | Value            |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `redis.enabled`                           | Whether to deploy a redis server to satisfy the applications requirements. To use an external redis instance set this to false and configure the externalRedis parameters | `true`           |
| `redis.auth.enabled`                      | Use password authentication                                                                                                                                               | `false`          |
| `redis.auth.password`                     | Redis&trade; password (both master and replica)                                                                                                                           | `""`             |
| `redis.auth.existingSecret`               | Name of an existing Kubernetes secret object containing the password                                                                                                      | `""`             |
| `redis.auth.existingSecretPasswordKey`    | Name of the key pointing to the password in your Kubernetes secret                                                                                                        | `redis-password` |
| `redis.architecture`                      | Cluster settings                                                                                                                                                          | `standalone`     |
| `redis.master.persistence.enabled`        | Enable database persistence using PVC                                                                                                                                     | `true`           |
| `externalRedis.host`                      | Host of the external database                                                                                                                                             | `""`             |
| `externalRedis.port`                      | Database port number                                                                                                                                                      | `6379`           |
| `externalRedis.password`                  | Password for the external Redis. Ignored if existingSecret is set                                                                                                         | `""`             |
| `externalRedis.existingSecret`            | Name of an existing Kubernetes secret object containing the password                                                                                                      | `""`             |
| `externalRedis.existingSecretPasswordKey` | Name of the key pointing to the password in your Kubernetes secret                                                                                                        | `redis-password` |


The above parameters map to the env variables defined in [bitnami/discourse](http://github.com/bitnami/bitnami-docker-discourse). For more information please refer to the [bitnami/discourse](http://github.com/bitnami/bitnami-docker-discourse) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set discourse.username=admin,discourse.password=password,postgresql.postgresqlPassword=secretpassword \
    bitnami/discourse
```

The above command sets the Discourse administrator account username and password to `admin` and `password` respectively. Additionally, it sets the Postgresql `bn_discourse` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/discourse
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Setting up replication

By default, this Chart only deploys a single pod running Discourse. Should you want to increase the number of replicas, you may follow these simple steps to ensure everything works smoothly:

> **Tip**: Running these steps ensures the PostgreSQL instance is correctly populated. If you already have an initialised DB, you may directly create a release with the desired number of replicas. Remind to set `discourse.skipInstall` to `true`!

1. Create a conventional release, that will be scaled later:
```console
$ helm install my-release bitnami/discourse
...
export DISCOURSE_PASSWORD=$(kubectl get secret --namespace default my-release-discourse -o jsonpath="{.data.discourse-password}" | base64 --decode)
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default my-release-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
...
```

2. Wait for the release to complete and Discourse to be running successfully.
```console
$ kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
my-release-discourse-744c48dd97-wx5h9   2/2     Running   0          5m11s
my-release-postgresql-0                 1/1     Running   0          5m10s
my-release-redis-master-0               1/1     Running   0          5m11s
```

3. Perform an upgrade specifying the number of replicas and the credentials used.
```console
$ helm upgrade my-release --set replicaCount=2,discourse.password=$DISCOURSE_PASSWORD,postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD,discourse.skipInstall=true bitnami/discourse
```

Note that for this to work properly, you need to provide ReadWriteMany PVCs. If you don't have a provisioner for this type of storage, we recommend that you install the NFS provisioner chart (with the correct parameters, such as `persistence.enabled=true` and `persistence.size=10Gi`) and map it to a RWO volume.

Then you can deploy Discourse chart using the proper parameters:

```console
persistence.storageClass=nfs
postgresql.persistence.storageClass=nfs
```

### Sidecars

If you have a need for additional containers to run within the same pod as Discourse (e.g. metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
   containerPort: 1234
```

If these sidecars export extra ports, you can add extra port definitions using the `service.extraPorts` value:

```yaml
service:
...
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

### Using an external database

Sometimes you may want to have Discourse connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use run a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#parameters). You should also disable the PostgreSQL installation with the `postgresql.enabled` option. For example with the following parameters:

```console
postgresql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.postgresqlPostgresUser=postgres
externalDatabase.postgresqlPostgresPassword=rootpassword
externalDatabase.database=mydatabase
externalDatabase.port=5432
```

Note also that if you disable PostgreSQL per above you MUST supply values for the `externalDatabase` connection.

In case the database already contains data from a previous Discourse installation, you need to set the `discourse.skipInstall` parameter to _true_. Otherwise, the container would execute the installation wizard and could modify the existing data in the database. This parameter force the container to not execute the Discourse installation wizard.

Similarly, you can specify an external Redis&trade; instance rather than installing one inside your cluster. First, you may disable the Redis&trade; installation with the `redis.enabled` option. As aforementioned, used the provided parameters to provide data about your instance:

```console
redis.enabled=false
externalRedis.host=myexternalhost
externalRedis.password=mypassword
externalRedis.port=5432
```

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik) you can utilize the ingress controller to serve your Discourse application.

To enable ingress integration, please set `ingress.enabled` to `true`

### Hosts

Most likely you will only want to have one hostname that maps to this Discourse installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object can be specified as an array.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

The actual TLS secret do not have to be generated by this chart. However, please note that if TLS is enabled, the ingress record will not work until this secret exists.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

### TLS Secrets

This chart will facilitate the creation of TLS secrets for use with the ingress controller, however, this is not required.  There are three common use cases:

- Helm generates/manages certificate secrets
- User generates/manages certificates separately
- An additional tool (like [kube-lego](https://kubeapps.com/charts/stable/kube-lego)) manages the secrets for the application

In the first two cases, one will need a certificate and a key.  We would expect them to look like this:

- certificate files should look like (and there can be more than one certificate if there is a certificate chain)

```console
-----BEGIN CERTIFICATE-----
MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
...
jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
-----END CERTIFICATE-----
```

- keys should look like:

```console
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
...
wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
-----END RSA PRIVATE KEY-----
```

If you are going to use Helm to manage the certificates, please copy these values into the `certificate` and `key` values for a given `ingress.secrets` entry.

If you are going to manage TLS secrets outside of Helm, please know that you can create a TLS secret (named `discourse.local-tls` for example).

Please see [this example](https://github.com/kubernetes/contrib/tree/master/ingress/controllers/nginx/examples/tls) for more information.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Discourse](https://github.com/bitnami/bitnami-docker-discourse) image stores the Discourse data and configurations at the `/bitnami` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Image

The `image` parameter allows specifying which image will be pulled for the chart.

#### Private registry

If you configure the `image` value to one in a private registry, you will need to [specify an image pull secret](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod).

1. Manually create image pull secret(s) in the namespace. See [this YAML example reference](https://kubernetes.io/docs/concepts/containers/images/#creating-a-secret-with-a-docker-config). Consult your image registry's documentation about getting the appropriate secret.
1. Note that the `imagePullSecrets` configuration value cannot currently be passed to helm using the `--set` parameter, so you must supply these using a `values.yaml` file, such as:

```yaml
imagePullSecrets:
  - name: SECRET_NAME
```

1. Install the chart

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 5.0.0

This major update the Redis&trade; subchart to its newest major, 15.0.0. [Here](https://github.com/bitnami/charts/tree/master/bitnami/redis#to-1500) you can find more info about the specific changes.

### To 4.0.0

The [Bitnami Discourse](https://github.com/bitnami/bitnami-docker-discourse) image was refactored and now the source code is published in GitHub in the [`rootfs`](https://github.com/bitnami/bitnami-docker-discourse/tree/master/2/debian-10/rootfs) folder of the container image repository.

Upgrades from previous versions require to specify `--set volumePermissions.enabled=true` in order for all features to work properly:

```console
$ helm upgrade discourse bitnami/discourse \
    --set discourse.host=$DISCOURSE_HOST \
    --set discourse.password=$DISCOURSE_PASSWORD \
    --set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD \
    --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC \
    --set volumePermissions.enabled=true
```

Full compatibility is not guaranteed due to the amount of involved changes, however no breaking changes are expected aside from the ones mentioned above.

### To 3.0.0

This major updates the Redis&trade; subchart to it newest major, 14.0.0, which contains breaking changes. For more information on this subchart's major and the steps needed to migrate your data from your previous release, please refer to [Redis&trade; upgrade notes.](https://github.com/bitnami/charts/tree/master/bitnami/redis#to-1400).

### To 2.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

**Considerations when upgrading to this version**

- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3
- This chart depends on the **PostgreSQL 10** instead of **PostgreSQL 9**. Apart from the same changes that are described in this section, there are also other major changes due to the master/slave nomenclature was replaced by primary/readReplica. [Here](https://github.com/bitnami/charts/pull/4385) you can find more information about the changes introduced.
- If you want to upgrade to this version from a previous one installed with Helm v3, it should be done reusing the PVC used to hold the PostgreSQL data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `discourse`):

> NOTE: Please, create a backup of your database before running any of those actions.

##### Export secrets and required values to update

```console
$ export DISCOURSE_HOST=$(kubectl get svc --namespace default discourse --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
$ export DISCOURSE_PASSWORD=$(kubectl get secret --namespace default discourse-discourse -o jsonpath="{.data.discourse-password}" | base64 --decode)
$ export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default discourse-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
$ export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=discourse,app.kubernetes.io/name=postgresql,role=master -o jsonpath="{.items[0].metadata.name}")
```

##### Delete statefulsets

Delete the Discourse deployment and delete the PostgreSQL statefulset. Notice the option `--cascade=false` in the latter:

```
$ kubectl delete deployments.apps discourse
$ kubectl delete statefulsets.apps --cascade=false discourse-postgresql
```

##### Upgrade the chart release

```console
$ helm upgrade discourse bitnami/discourse \
    --set discourse.host=$DISCOURSE_HOST \
    --set discourse.password=$DISCOURSE_PASSWORD \
    --set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD \
    --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC
```

##### Force new statefulset to create a new pod for postgresql

```console
$ kubectl delete pod discourse-postgresql-0
```
Finally, you should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=postgresql,app.kubernetes.io/name=postgresql,role=primary -o jsonpath="{.items[0].metadata.name}")
...
postgresql 08:05:12.59 INFO  ==> Deploying PostgreSQL with persisted data...
...
```

**Useful links**

- https://docs.bitnami.com/tutorials/resolve-helm2-helm3-post-migration-issues/
- https://helm.sh/docs/topics/v2_v3_migration/
- https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/

### To 1.0.0

This new major version includes the following changes:

* PostgreSQL dependency version was bumped to a new major version `9.X.X`, which includes changes that do no longer guarantee backwards compatibility. Check [PostgreSQL Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#900) for more information.
* Redis&trade; dependency version was bumped to a new major version `11.X.X`, which includes breaking changes regarding sentinel. Discourse does not use this type of setup, so no issues are expected to happen in this case. Check [Redis&trade; Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/redis#to-1100) for more information.
* Some non-breaking changes so as to use the `bitnami/common` library chart.

As a consequence, backwards compatibility from previous versions is not guaranteed during the upgrade. To upgrade to this new version `1.0.0` there are two alternatives:

* Install a new Discourse chart, and migrate your Discourse site using the [built-in backup/restore feature](https://meta.discourse.org/t/create-download-and-restore-a-backup-of-your-discourse-database/122710).

* Reuse the PVC used to hold the PostgreSQL data on your previous release. To do so, follow the instructions below.

> NOTE: Please, make sure to create or have a backup of your database before running any of those actions.

1. Old version is up and running

  ```console
  $ helm ls
  NAME	    NAMESPACE	REVISION	UPDATED                              	STATUS  	CHART          	APP VERSION
  discourse 	default  	2       	2020-10-22 12:10:16.454369 +0200 CEST	deployed	discourse-0.5.1	2.5.3

  $ kubectl get pods
  NAME                                   READY   STATUS    RESTARTS   AGE
  discourse-discourse-7554ddb864-d55ls   2/2     Running   0          3s
  discourse-postgresql-0                 1/1     Running   0          16s
  discourse-redis-master-0               1/1     Running   0          16s
  ```

2. Export both PostgreSQL and Discourse credentials in order to provide them in the update

  ```console
  $ export DISCOURSE_PASSWORD=$(kubectl get secret --namespace default discourse-discourse-discourse -o jsonpath="{.data.discourse-password}" | base64 --decode)

  $ export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default discourse-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
  ```

  > NOTE: You will need to export Redis&trade; credentials as well if your setup makes use of them.

3. Scale down the Discourse deployment and delete the PostgreSQL statefulset. Notice the option `--cascade=false` in the latter.

  ```console
  $ kubectl scale --replicas 0 deployment.apps/discourse-discourse
  deployment.apps/discourse-discourse scaled

  $ kubectl delete statefulset.apps/discourse-postgresql --cascade=false
  statefulset.apps "discourse-postgresql" deleted
  ```

4. Now the upgrade works

  ```console
  $ helm upgrade discourse bitnami/discourse --set discourse.password=$DISCOURSE_PASSWORD --set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD --set skipInstall=true
  $ helm ls
  NAME	      NAMESPACE	REVISION	UPDATED                              	STATUS  	CHART      	APP VERSION
  discourse 	default  	3       	2020-10-22 13:03:33.876084 +0200 CEST	deployed	discourse-1.0.0	2.5.3
  ```

5. You can kill the existing PostgreSQL pod and the new statefulset is going to create a new one

  ```console
  $ kubectl delete pod discourse-postgresql-0
  pod "discourse-postgresql-0" deleted

  $ kubectl get pods
  NAME                                   READY   STATUS    RESTARTS   AGE
  discourse-discourse-58fff99578-2xbjq   2/2     Running   3          5m4s
  discourse-postgresql-0                 1/1     Running   0          3m42s
  discourse-redis-master-0               1/1     Running   0          4m58s
  ```

### To 0.4.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.
