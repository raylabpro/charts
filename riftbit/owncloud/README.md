# ownCloud

[ownCloud](https://owncloud.org/) is a file sharing server that puts the control and security of your own data back into your hands.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/owncloud
```

## Introduction

This chart bootstraps an [ownCloud](https://github.com/bitnami/bitnami-docker-owncloud) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the ownCloud application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/owncloud
```

The command deploys ownCloud on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

| Name               | Description                                                                              | Value |
| ------------------ | ---------------------------------------------------------------------------------------- | ----- |
| `kubeVersion`      | Force target Kubernetes version (using Helm capabilities if not set)                     | `""`  |
| `nameOverride`     | String to partially override owncloud.fullname template (will maintain the release name) | `""`  |
| `fullnameOverride` | String to fully override owncloud.fullname template                                      | `""`  |
| `extraDeploy`      | Array of extra objects to deploy with the release (evaluated as a template)              | `[]`  |


### ownCloud parameters

| Name                                 | Description                                                                                                  | Value                  |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------ | ---------------------- |
| `image.registry`                     | ownCloud image registry                                                                                      | `docker.io`            |
| `image.repository`                   | ownCloud image repository                                                                                    | `bitnami/owncloud`     |
| `image.tag`                          | ownCloud Image tag (immutable tags are recommended)                                                          | `10.8.0-debian-10-r36` |
| `image.pullPolicy`                   | ownCloud image pull policy                                                                                   | `IfNotPresent`         |
| `image.pullSecrets`                  | Specify docker-registry secret names as an array                                                             | `[]`                   |
| `image.debug`                        | Specify if debug logs should be enabled                                                                      | `false`                |
| `hostAliases`                        | Deployment pod host aliases                                                                                  | `[]`                   |
| `replicaCount`                       | Number of replicas (requires ReadWriteMany PVC support)                                                      | `1`                    |
| `owncloudSkipInstall`                | Skip ownCloud installation wizard. Useful for migrations and restoring from SQL dump                         | `false`                |
| `owncloudHost`                       | ownCloud host to create application URLs (when ingress, it will be ignored)                                  | `""`                   |
| `owncloudUsername`                   | User of the application                                                                                      | `user`                 |
| `owncloudPassword`                   | Application password                                                                                         | `""`                   |
| `owncloudEmail`                      | Admin email                                                                                                  | `user@example.com`     |
| `allowEmptyPassword`                 | Allow DB blank passwords                                                                                     | `false`                |
| `command`                            | Override default container command (useful when using custom images)                                         | `[]`                   |
| `args`                               | Override default container args (useful when using custom images)                                            | `[]`                   |
| `commonAnnotations`                  | Common annotations to add to all ownCloud resources (sub-charts are not considered). Evaluated as a template | `{}`                   |
| `commonLabels`                       | Common labels to add to all ownCloud resources (sub-charts are not considered). Evaluated as a template      | `{}`                   |
| `updateStrategy.type`                | Update strategy - only really applicable for deployments with RWO PVs attached                               | `RollingUpdate`        |
| `extraEnvVars`                       | An array to add extra env vars                                                                               | `[]`                   |
| `extraEnvVarsCM`                     | ConfigMap with extra environment variables                                                                   | `""`                   |
| `extraEnvVarsSecret`                 | Secret with extra environment variables                                                                      | `""`                   |
| `extraVolumes`                       | Extra volumes to add to the deployment. Requires setting `extraVolumeMounts`                                 | `[]`                   |
| `extraVolumeMounts`                  | Extra volume mounts to add to the container. Normally used with `extraVolumes`                               | `[]`                   |
| `initContainers`                     | Extra init containers to add to the deployment                                                               | `[]`                   |
| `sidecars`                           | Extra sidecar containers to add to the deployment                                                            | `[]`                   |
| `tolerations`                        | Tolerations for pod assignment                                                                               | `[]`                   |
| `existingSecret`                     | Name of a secret with the application password                                                               | `""`                   |
| `smtpHost`                           | SMTP host                                                                                                    | `""`                   |
| `smtpPort`                           | SMTP port                                                                                                    | `""`                   |
| `smtpUser`                           | SMTP user                                                                                                    | `""`                   |
| `smtpPassword`                       | SMTP password                                                                                                | `""`                   |
| `smtpProtocol`                       | SMTP Protocol (options: ssl,tls, nil)                                                                        | `""`                   |
| `containerPorts.http`                | Sets HTTP port inside NGINX container                                                                        | `8080`                 |
| `containerPorts.https`               | Sets HTTPS port inside NGINX container                                                                       | `8443`                 |
| `sessionAffinity`                    | Control where client requests go, to the same pod or round-robin                                             | `None`                 |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                          | `""`                   |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                     | `soft`                 |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                    | `""`                   |
| `nodeAffinityPreset.key`             | Node label key to match Ignored if `affinity` is set.                                                        | `""`                   |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set.                                                    | `[]`                   |
| `affinity`                           | Affinity for pod assignment                                                                                  | `{}`                   |
| `nodeSelector`                       | Node labels for pod assignment. Evaluated as a template.                                                     | `{}`                   |
| `resources`                          | Metrics exporter resource requests and limits                                                                | `{}`                   |
| `podSecurityContext.enabled`         | Enable ownCloud pods' Security Context                                                                       | `true`                 |
| `podSecurityContext.fsGroup`         | ownCloud pods' group ID                                                                                      | `1001`                 |
| `containerSecurityContext.enabled`   | Enable ownCloud containers' Security Context                                                                 | `true`                 |
| `containerSecurityContext.runAsUser` | ownCloud containers' Security Context                                                                        | `1001`                 |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                                         | `true`                 |
| `livenessProbe.path`                 | Request path for livenessProbe                                                                               | `/status.php`          |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                      | `120`                  |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                             | `10`                   |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                            | `5`                    |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                          | `6`                    |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                          | `1`                    |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                                        | `true`                 |
| `readinessProbe.path`                | Request path for readinessProbe                                                                              | `/status.php`          |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                     | `30`                   |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                            | `5`                    |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                           | `3`                    |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                         | `6`                    |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                         | `1`                    |
| `startupProbe.enabled`               | Enable startupProbe                                                                                          | `false`                |
| `startupProbe.path`                  | Request path for startupProbe                                                                                | `/status.php`          |
| `startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                                       | `0`                    |
| `startupProbe.periodSeconds`         | Period seconds for startupProbe                                                                              | `10`                   |
| `startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                                             | `3`                    |
| `startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                                           | `60`                   |
| `startupProbe.successThreshold`      | Success threshold for startupProbe                                                                           | `1`                    |
| `customLivenessProbe`                | Override default liveness probe                                                                              | `{}`                   |
| `customReadinessProbe`               | Override default readiness probe                                                                             | `{}`                   |
| `customStartupProbe`                 | Override default startup probe                                                                               | `{}`                   |
| `lifecycleHooks`                     | LifecycleHook to set additional configuration before or after startup                                        | `{}`                   |
| `podAnnotations`                     | Pod annotations                                                                                              | `{}`                   |
| `podLabels`                          | Pod extra labels                                                                                             | `{}`                   |


### Database parameters

| Name                                        | Description                                                                              | Value               |
| ------------------------------------------- | ---------------------------------------------------------------------------------------- | ------------------- |
| `mariadb.enabled`                           | Whether to deploy a mariadb server to satisfy the applications database requirements     | `true`              |
| `mariadb.architecture`                      | MariaDB architecture. Allowed values: `standalone` or `replication`                      | `standalone`        |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                                     | `""`                |
| `mariadb.auth.database`                     | Database name to create                                                                  | `bitnami_owncloud`  |
| `mariadb.auth.username`                     | Database user to create                                                                  | `bn_owncloud`       |
| `mariadb.auth.password`                     | Password for the database                                                                | `""`                |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                                    | `true`              |
| `mariadb.primary.persistence.storageClass`  | MariaDB primary persistent volume storage Class                                          | `""`                |
| `mariadb.primary.persistence.accessModes`   | Database Persistent Volume Access Modes                                                  | `["ReadWriteOnce"]` |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                                          | `8Gi`               |
| `mariadb.primary.persistence.hostPath`      | Set path in case you want to use local host path volumes (not recommended in production) | `""`                |
| `mariadb.primary.persistence.existingClaim` | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                 | `""`                |
| `externalDatabase.host`                     | Host of the existing database                                                            | `""`                |
| `externalDatabase.port`                     | Port of the existing database                                                            | `3306`              |
| `externalDatabase.user`                     | Existing username in the external db                                                     | `bn_owncloud`       |
| `externalDatabase.password`                 | Password for the above username                                                          | `""`                |
| `externalDatabase.database`                 | Name of the existing database                                                            | `bitnami_owncloud`  |


### Persistence parameters

| Name                        | Description                                                                | Value           |
| --------------------------- | -------------------------------------------------------------------------- | --------------- |
| `persistence.enabled`       | Enable persistence using PVC                                               | `true`          |
| `persistence.storageClass`  | PVC Storage Class for ownCloud volume                                      | `""`            |
| `persistence.accessMode`    | PVC Access Mode for ownCloud volume                                        | `ReadWriteOnce` |
| `persistence.size`          | PVC Storage Request for ownCloud volume                                    | `8Gi`           |
| `persistence.existingClaim` | An Existing PVC name for ownCloud volume                                   | `""`            |
| `persistence.hostPath`      | If defined, the owncloud-data volume will mount to the specified hostPath. | `""`            |


### Volume Permissions parameters

| Name                                   | Description                                                                                                                                               | Value                   |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `volumePermissions.enabled`            | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                 |
| `volumePermissions.image.registry`     | Init container volume-permissions image registry                                                                                                          | `docker.io`             |
| `volumePermissions.image.repository`   | Init container volume-permissions image repository                                                                                                        | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`          | Init container volume-permissions image tag (immutable tags are recommended)                                                                              | `10-debian-10-r188`     |
| `volumePermissions.image.pullPolicy`   | Init container volume-permissions image pull policy                                                                                                       | `Always`                |
| `volumePermissions.image.pullSecrets`  | Specify docker-registry secret names as an array                                                                                                          | `[]`                    |
| `volumePermissions.resources.limits`   | The resources limits for the container                                                                                                                    | `{}`                    |
| `volumePermissions.resources.requests` | The requested resources for the container                                                                                                                 | `{}`                    |


### Traffic Exposure Parameters

| Name                               | Description                                                                                   | Value                    |
| ---------------------------------- | --------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Kubernetes Service type                                                                       | `LoadBalancer`           |
| `service.port`                     | Service HTTP port                                                                             | `8080`                   |
| `service.httpsPort`                | Service HTTPS port                                                                            | `8443`                   |
| `service.clusterIP`                | Service cluster IP                                                                            | `""`                     |
| `service.loadBalancerSourceRanges` | Control hosts connecting to "LoadBalancer" only                                               | `[]`                     |
| `service.loadBalancerIP`           | Load balancer IP for the ownCloud Service (optional, cloud specific)                          | `""`                     |
| `service.nodePorts.http`           | Kubernetes HTTP node port                                                                     | `""`                     |
| `service.nodePorts.https`          | Kubernetes HTTPS node port                                                                    | `""`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                          | `Cluster`                |
| `ingress.enabled`                  | Set to true to enable ingress record generation                                               | `false`                  |
| `ingress.certManager`              | Set this to true in order to add the corresponding annotations for cert-manager               | `false`                  |
| `ingress.hostname`                 | Default host for the ingress resource                                                         | `owncloud.local`         |
| `ingress.pathType`                 | Ingress path type                                                                             | `ImplementationSpecific` |
| `ingress.annotations`              | Ingress annotations                                                                           | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the hostname defined at ingress.hostname parameter               | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                      | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.        | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets | `[]`                     |


### Metrics parameters

| Name                          | Description                                                | Value                     |
| ----------------------------- | ---------------------------------------------------------- | ------------------------- |
| `metrics.enabled`             | Start a side-car prometheus exporter                       | `false`                   |
| `metrics.image.registry`      | Apache exporter image registry                             | `docker.io`               |
| `metrics.image.repository`    | Apache exporter image repository                           | `bitnami/apache-exporter` |
| `metrics.image.tag`           | Apache exporter image tag (immutable tags are recommended) | `0.10.0-debian-10-r42`    |
| `metrics.image.pullPolicy`    | Image pull policy                                          | `IfNotPresent`            |
| `metrics.image.pullSecrets`   | Specify docker-registry secret names as an array           | `[]`                      |
| `metrics.resources`           | Metrics exporter resource requests and limits              | `{}`                      |
| `metrics.service.type`        |                                                            | `ClusterIP`               |
| `metrics.service.port`        | Service Metrics port                                       | `9117`                    |
| `metrics.service.annotations` | Annotations for the Prometheus exporter service            | `{}`                      |


### Certificate injection parameters

| Name                                                 | Description                                                          | Value                                    |
| ---------------------------------------------------- | -------------------------------------------------------------------- | ---------------------------------------- |
| `certificates.customCertificate.certificateSecret`   | Secret containing the certificate and key to add                     | `""`                                     |
| `certificates.customCertificate.chainSecret.name`    | Name of the secret containing the certificate chain                  | `""`                                     |
| `certificates.customCertificate.chainSecret.key`     | Key of the certificate chain file inside the secret                  | `""`                                     |
| `certificates.customCertificate.certificateLocation` | Location in the container to store the certificate                   | `/etc/ssl/certs/ssl-cert-snakeoil.pem`   |
| `certificates.customCertificate.keyLocation`         | Location in the container to store the private key                   | `/etc/ssl/private/ssl-cert-snakeoil.key` |
| `certificates.customCertificate.chainLocation`       | Location in the container to store the certificate chain             | `/etc/ssl/certs/mychain.pem`             |
| `certificates.customCAs`                             | Defines a list of secrets to import into the container trust store   | `[]`                                     |
| `certificates.command`                               | Override default container command (useful when using custom images) | `[]`                                     |
| `certificates.args`                                  | Override default container args (useful when using custom images)    | `[]`                                     |
| `certificates.extraEnvVars`                          | Container sidecar extra environment variables                        | `[]`                                     |
| `certificates.extraEnvVarsCM`                        | ConfigMap with extra environment variables                           | `""`                                     |
| `certificates.extraEnvVarsSecret`                    | Secret with extra environment variables                              | `""`                                     |
| `certificates.image.registry`                        | Container sidecar registry                                           | `docker.io`                              |
| `certificates.image.repository`                      | Container sidecar image repository                                   | `bitnami/bitnami-shell`                  |
| `certificates.image.tag`                             | Container sidecar image tag (immutable tags are recommended)         | `10-debian-10-r188`                      |
| `certificates.image.pullPolicy`                      | Container sidecar image pull policy                                  | `IfNotPresent`                           |
| `certificates.image.pullSecrets`                     | Container sidecar image pull secrets                                 | `[]`                                     |


The above parameters map to the env variables defined in [bitnami/owncloud](http://github.com/bitnami/bitnami-docker-owncloud). For more information please refer to the [bitnami/owncloud](http://github.com/bitnami/bitnami-docker-owncloud) image documentation.

> **Note**:
>
> For ownCloud to function correctly, you should specify the `owncloudHost` parameter to specify the FQDN (recommended) or the public IP address of the ownCloud service.
>
> Optionally, you can specify the `owncloudLoadBalancerIP` parameter to assign a reserved IP address to the ownCloud service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create owncloud-public-ip
> ```
>
> The reserved IP address can be associated to the ownCloud service by specifying it as the value of the `owncloudLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set owncloudUsername=admin,owncloudPassword=password,mariadb.auth.rootPassword=secretpassword \
    bitnami/owncloud
```

The above command sets the ownCloud administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/owncloud
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

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

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` paremeter. Find more infomation about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami ownCloud](https://github.com/bitnami/bitnami-docker-owncloud) image stores the ownCloud data and configurations at the `/bitnami/owncloud` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Existing PersistentVolumeClaim

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart

    ```bash
    $ helm install my-release --set persistence.existingClaim=PVC_NAME bitnami/owncloud
    ```

### Host path

#### System compatibility

- The local filesystem accessibility to a container in a pod with `hostPath` has been tested on OSX/MacOS with xhyve, and Linux with VirtualBox.
- Windows has not been tested with the supported VM drivers. Minikube does however officially support [Mounting Host Folders](https://github.com/kubernetes/minikube/blob/master/docs/host_folder_mount.md) per pod. Or you may manually sync your container whenever host files are changed with tools like [docker-sync](https://github.com/EugenMayer/docker-sync) or [docker-bg-sync](https://github.com/cweagans/docker-bg-sync).

#### Mounting steps

1. The specified `hostPath` directory must already exist (create one if it does not).
1. Install the chart

    ```bash
    $ helm install my-release --set persistence.hostPath=/PATH/TO/HOST/MOUNT bitnami/owncloud
    ```

    This will mount the `owncloud-data` volume into the `hostPath` directory. The site data will be persisted if the mount path contains valid data, else the site data will be initialized at first launch.
1. Because the container cannot control the host machine's directory permissions, you must set the ownCloud file directory permissions yourself and disable or clear ownCloud cache.

## CA Certificates

Custom CA certificates not included in the base docker image can be added by means of existing secrets. The secret must exist in the same namespace and contain the desired CA certificates to import. By default, all found certificate files will be loaded.

```yaml
certificates:
  customCAs:
  - secret: my-ca-1
  - secret: my-ca-2
```

> Tip! You can create a secret containing your CA certificates using the following command:
```bash
kubectl create secret generic my-ca-1 --from-file my-ca-1.crt
```

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 10.0.0

In this major there were three main changes introduced:

- Parameter standarizations
- Migration to non-root

To upgrade to `8.0.0`, backup ownCloud data and the previous MariaDB databases, install a new ownCloud chart and import the backups and data, ensuring the `1001` user has the appropriate permissions on the migrated volume.

**1. Chart standarizations**

This upgrade adapts the chart to the latest Bitnami good practices. Check the Parameters section for more information. In summary:

- Lots of new parameters were added, including SMTP configuration, for using existing DBs (`owncloudSkipInstall`), configuring security context, etc.
- Some parameters were renamed or disappeared in favor of new ones in this major version. For example, `persistence.owncloud.*` parameters were deprecated in favor of `persistence.*`.
- This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated the chart dependencies before executing any upgrade.

**2. Migration of the ownCloud image to non-root**

The [Bitnami ownCloud](https://github.com/bitnami/bitnami-docker-owncloud) image was migrated to a "non-root" user approach. Previously the container ran as the `root` user and the Apache daemon was started as the `daemon` user. From now on, both the container and the Apache daemon run as user `1001`. Consequences:

- The HTTP/HTTPS ports exposed by the container are now `8080/8443` instead of `80/443`.
- Backwards compatibility is not guaranteed. Uninstall & install the chart again to obtain the latest version.

You can revert this behavior by setting the parameters `containerSecurityContext.runAsUser` to `root`.

### To 9.0.0

In this major there were two main changes introduced:

1. Adaptation to Helm v2 EOL
2. Updated MariaDB dependency version

Please read the update notes carefully.

**1. Adaptation to Helm v2 EOL**

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

**2. Updated MariaDB dependency version**

In this major the MariaDB dependency version was also bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-800) for more information.

To upgrade to `9.0.0`, it should be done reusing the PVCs used to hold both the MariaDB and ownCloud data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `owncloud` and that a `rootUser.password` was defined for MariaDB in `values.yaml` when the chart was first installed):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the names of the PVCs used to hold both the MariaDB and ownCloud data on your current release:

```console
export OWNCLOUD_HOST=$(kubectl get svc --namespace default owncloud --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
export OWNCLOUD_PASSWORD=$(kubectl get secret --namespace default owncloud -o jsonpath="{.data.owncloud-password}" | base64 --decode)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default owncloud-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default owncloud-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=owncloud -o jsonpath="{.items[0].metadata.name}")
```

Delete the ownCloud deployment and delete the MariaDB statefulset. Notice the option `--cascade=false` in the latter:

```console
$ kubectl delete deployments.apps owncloud

$ kubectl delete statefulsets.apps owncloud-mariadb --cascade=false
```

Now the upgrade works:

```console
$ helm upgrade owncloud bitnami/owncloud --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set owncloudPassword=$OWNCLOUD_PASSWORD --set owncloudHost=$OWNCLOUD_HOST
```

You will have to delete the existing MariaDB pod and the new statefulset is going to create a new one

```console
$ kubectl delete pod owncloud-mariadb-0
```

Finally, you should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=owncloud,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

### To 7.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17304 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is owncloud:

```console
$ kubectl patch deployment owncloud-owncloud --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset owncloud-mariadb --cascade=false
```
