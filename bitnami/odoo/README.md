# Odoo

[Odoo](https://www.odoo.com/) is a suite of web-based open source business apps. The main Odoo Apps include an Open Source CRM, Website Builder, eCommerce, Project Management, Billing & Accounting, Point of Sale, Human Resources, Marketing, Manufacturing, Purchase Management, ...

Odoo Apps can be used as stand-alone applications, but they also integrate seamlessly so you get a full-featured Open Source ERP when you install several Apps.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/odoo
```

## Introduction

This chart bootstraps a [Odoo](https://github.com/bitnami/bitnami-docker-odoo) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/odoo
```

The command deploys Odoo on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

| Name                | Description                                        | Value                        |
| ------------------- | -------------------------------------------------- | ---------------------------- |
| `kubeVersion`       | Override Kubernetes version                        | `""`                         |
| `nameOverride`      | String to partially override common.names.fullname | `""`                         |
| `fullnameOverride`  | String to fully override common.names.fullname     | `""`                         |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`                         |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`                         |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`                         |
| `image.registry`    | Odoo image registry                                | `docker.io`                  |
| `image.repository`  | Odoo image repository                              | `bitnami/odoo`               |
| `image.tag`         | Odoo image tag (immutable tags are recommended)    | `14.0.20210910-debian-10-r0` |
| `image.pullPolicy`  | Odoo image pull policy                             | `IfNotPresent`               |
| `image.pullSecrets` | Odoo image pull secrets                            | `[]`                         |
| `image.debug`       | Enable image debug mode                            | `false`                      |


### Odoo Configuration parameters

| Name                    | Description                                                          | Value              |
| ----------------------- | -------------------------------------------------------------------- | ------------------ |
| `odooEmail`             | Odoo user email                                                      | `user@example.com` |
| `odooPassword`          | Odoo user password                                                   | `""`               |
| `loadDemoData`          | Whether to load demo data for all modules during initialization      | `false`            |
| `customPostInitScripts` | Custom post-init.d user scripts                                      | `{}`               |
| `smtpHost`              | SMTP server host                                                     | `""`               |
| `smtpPort`              | SMTP server port                                                     | `""`               |
| `smtpUser`              | SMTP username                                                        | `""`               |
| `smtpPassword`          | SMTP user password                                                   | `""`               |
| `smtpProtocol`          | SMTP protocol                                                        | `""`               |
| `existingSecret`        | Name of existing secret containing Odoo credentials                  | `""`               |
| `smtpExistingSecret`    | The name of an existing secret with SMTP credentials                 | `""`               |
| `allowEmptyPassword`    | Allow the container to be started with blank passwords               | `false`            |
| `command`               | Override default container command (useful when using custom images) | `[]`               |
| `args`                  | Override default container args (useful when using custom images)    | `[]`               |
| `extraEnvVars`          | Array with extra environment variables to add to the Odoo container  | `[]`               |
| `extraEnvVarsCM`        | Name of existing ConfigMap containing extra env vars                 | `""`               |
| `extraEnvVarsSecret`    | Name of existing Secret containing extra env vars                    | `""`               |


### Odoo deployment parameters

| Name                                 | Description                                                                               | Value           |
| ------------------------------------ | ----------------------------------------------------------------------------------------- | --------------- |
| `replicaCount`                       | Number of Odoo replicas to deploy                                                         | `1`             |
| `updateStrategy.type`                | Odoo deployment strategy type                                                             | `RollingUpdate` |
| `updateStrategy.rollingUpdate`       | Odoo deployment rolling update configuration parameters                                   | `{}`            |
| `schedulerName`                      | Alternate scheduler                                                                       | `""`            |
| `serviceAccount.create`              | Specifies whether a ServiceAccount should be created                                      | `true`          |
| `serviceAccount.name`                | The name of the ServiceAccount to create                                                  | `""`            |
| `hostAliases`                        | Odoo pod host aliases                                                                     | `[]`            |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for Odoo pods                         | `[]`            |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for Odoo container(s)            | `[]`            |
| `sidecars`                           | Add additional sidecar containers to the Odoo pod                                         | `[]`            |
| `initContainers`                     | Add additional init containers to the Odoo pods                                           | `[]`            |
| `podLabels`                          | Extra labels for Odoo pods                                                                | `{}`            |
| `podAnnotations`                     | Annotations for Odoo pods                                                                 | `{}`            |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set                                     | `""`            |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set                                  | `[]`            |
| `affinity`                           | Affinity for pod assignment                                                               | `{}`            |
| `nodeSelector`                       | Node labels for pod assignment                                                            | `{}`            |
| `tolerations`                        | Tolerations for pod assignment                                                            | `[]`            |
| `resources.limits`                   | The resources limits for the Odoo container                                               | `{}`            |
| `resources.requests`                 | The requested resources for the Odoo container                                            | `{}`            |
| `containerPort`                      | Odoo HTTP container port                                                                  | `8069`          |
| `podSecurityContext.enabled`         | Enabled Odoo pods' Security Context                                                       | `false`         |
| `podSecurityContext.fsGroup`         | Set Odoo pod's Security Context fsGroup                                                   | `1001`          |
| `containerSecurityContext.enabled`   | Enabled Odoo containers' Security Context                                                 | `false`         |
| `containerSecurityContext.runAsUser` | Set Odoo container's Security Context runAsUser                                           | `1001`          |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                      | `true`          |
| `livenessProbe.path`                 | Path for to check for livenessProbe                                                       | `/`             |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                   | `600`           |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                          | `30`            |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                         | `5`             |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                       | `6`             |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                       | `1`             |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                     | `true`          |
| `readinessProbe.path`                | Path to check for readinessProbe                                                          | `/`             |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                  | `30`            |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                         | `10`            |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                        | `5`             |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                      | `6`             |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                      | `1`             |
| `startupProbe.enabled`               | Enable startupProbe                                                                       | `false`         |
| `startupProbe.path`                  | Path to check for startupProbe                                                            | `/`             |
| `startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                    | `300`           |
| `startupProbe.periodSeconds`         | Period seconds for startupProbe                                                           | `10`            |
| `startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                          | `5`             |
| `startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                        | `6`             |
| `startupProbe.successThreshold`      | Success threshold for startupProbe                                                        | `1`             |
| `customLivenessProbe`                | Custom livenessProbe that overrides the default one                                       | `{}`            |
| `customReadinessProbe`               | Custom readinessProbe that overrides the default one                                      | `{}`            |
| `customStartupProbe`                 | Custom startupProbe that overrides the default one                                        | `{}`            |


### Traffic Exposure Parameters

| Name                               | Description                                                                                           | Value                    |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Odoo service type                                                                                     | `LoadBalancer`           |
| `service.port`                     | Odoo service HTTP port                                                                                | `80`                     |
| `service.nodePort`                 | Node port for HTTP                                                                                    | `""`                     |
| `service.clusterIP`                | Odoo service Cluster IP                                                                               | `""`                     |
| `service.loadBalancerIP`           | Odoo service Load Balancer IP                                                                         | `""`                     |
| `service.loadBalancerSourceRanges` | Odoo service Load Balancer sources                                                                    | `[]`                     |
| `service.externalTrafficPolicy`    | Odoo service external traffic policy                                                                  | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Odoo service                                                        | `{}`                     |
| `service.extraPorts`               | Extra port to expose on Odoo service                                                                  | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for Odoo                                                             | `false`                  |
| `ingress.certManager`              | Add the corresponding annotations for cert-manager integration                                        | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm          | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                     | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                         | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                   | `odoo.local`             |
| `ingress.path`                     | Default path for the ingress record                                                                   | `/`                      |
| `ingress.annotations`              | Additional custom annotations for the ingress record                                                  | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                         | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                            | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                   | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                    | `[]`                     |


### Persistence Parameters

| Name                                          | Description                                                                                     | Value           |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------- | --------------- |
| `persistence.enabled`                         | Enable persistence using Persistent Volume Claims                                               | `true`          |
| `persistence.storageClass`                    | Persistent Volume storage class                                                                 | `""`            |
| `persistence.accessModes`                     | Persistent Volume access modes                                                                  | `[]`            |
| `persistence.accessMode`                      | Persistent Volume access mode (DEPRECATED: use `persistence.accessModes` instead)               | `ReadWriteOnce` |
| `persistence.size`                            | Persistent Volume size                                                                          | `10Gi`          |
| `persistence.dataSource`                      | Custom PVC data source                                                                          | `{}`            |
| `persistence.existingClaim`                   | The name of an existing PVC to use for persistence                                              | `""`            |
| `volumePermissions.enabled`                   | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`         |
| `volumePermissions.resources.limits`          | The resources limits for the init container                                                     | `{}`            |
| `volumePermissions.resources.requests`        | The requested resources for the init container                                                  | `{}`            |
| `volumePermissions.securityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`             |


### Other Parameters

| Name                       | Description                                                    | Value   |
| -------------------------- | -------------------------------------------------------------- | ------- |
| `pdb.create`               | Enable a Pod Disruption Budget creation                        | `false` |
| `pdb.minAvailable`         | Minimum number/percentage of pods that should remain scheduled | `1`     |
| `pdb.maxUnavailable`       | Maximum number/percentage of pods that may be made unavailable | `""`    |
| `autoscaling.enabled`      | Enable Horizontal POD autoscaling for Odoo                     | `false` |
| `autoscaling.minReplicas`  | Minimum number of Odoo replicas                                | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of Odoo replicas                                | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage                              | `50`    |
| `autoscaling.targetMemory` | Target Memory utilization percentage                           | `50`    |


### Database Parameters

| Name                                          | Description                                                                       | Value           |
| --------------------------------------------- | --------------------------------------------------------------------------------- | --------------- |
| `postgresql.enabled`                          | Deploy PostgreSQL container(s)                                                    | `true`          |
| `postgresql.postgresqlUsername`               | PostgreSQL username                                                               | `bn_odoo`       |
| `postgresql.postgresqlPassword`               | PostgreSQL password                                                               | `""`            |
| `postgresql.postgresqlDatabase`               | PostgreSQL database                                                               | `bitnami_odoo`  |
| `postgresql.existingSecret`                   | Name of existing secret object                                                    | `""`            |
| `postgresql.persistence.enabled`              | Enable PostgreSQL persistence using PVC                                           | `true`          |
| `postgresql.persistence.existingClaim`        | Provide an existing `PersistentVolumeClaim`, the value is evaluated as a template | `""`            |
| `postgresql.persistence.storageClass`         | PVC Storage Class for PostgreSQL volume                                           | `""`            |
| `postgresql.persistence.accessMode`           | PVC Access Mode for PostgreSQL volume                                             | `ReadWriteOnce` |
| `postgresql.persistence.size`                 | PVC Storage Request for PostgreSQL volume                                         | `8Gi`           |
| `externalDatabase.host`                       | External Database server host                                                     | `""`            |
| `externalDatabase.port`                       | External Database server port                                                     | `5432`          |
| `externalDatabase.user`                       | External Database username                                                        | `bn_odoo`       |
| `externalDatabase.password`                   | External Database user password                                                   | `""`            |
| `externalDatabase.database`                   | External Database database name                                                   | `bitnami_odoo`  |
| `externalDatabase.create`                     | Enable PostgreSQL user and database creation (when using an external db)          | `true`          |
| `externalDatabase.postgresqlPostgresUser`     | External Database admin username                                                  | `postgres`      |
| `externalDatabase.postgresqlPostgresPassword` | External Database admin password                                                  | `""`            |
| `externalDatabase.existingSecret`             | Name of existing secret object                                                    | `""`            |


The above parameters map to the env variables defined in [bitnami/odoo](http://github.com/bitnami/bitnami-docker-odoo). For more information please refer to the [bitnami/odoo](http://github.com/bitnami/bitnami-docker-odoo) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set odooPassword=password,postgresql.postgresPassword=secretpassword \
    bitnami/odoo
```

The above command sets the Odoo administrator account password to `password` and the PostgreSQL `postgres` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/odoo
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use a different Odoo version

To modify the application version used in this chart, specify a different version of the image using the `image.tag` parameter and/or a different repository using the `image.repository` parameter. Refer to the [chart documentation for more information on these parameters and how to use them with images from a private registry](https://docs.bitnami.com/kubernetes/apps/odoo/configuration/change-image-version/).

### Using an external database

Sometimes you may want to have Odoo connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#parameters). You should also disable the PostgreSQL installation with the `postgresql.enabled` option. For example using the following parameters:

```console
postgresql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.port=3306
```

Note also if you disable PostgreSQL per above you MUST supply values for the `externalDatabase` connection.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as Odoo, you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
       containerPort: 1234
```

Similarly, you can add extra init containers using the `initContainers` parameter.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Odoo](https://github.com/bitnami/bitnami-docker-odoo) image stores the Odoo data and configurations at the `/bitnami/odoo` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### 19.0.0

The [Bitnami Odoo](https://github.com/bitnami/bitnami-docker-odoo) image was refactored and now the source code is published in GitHub in the [`rootfs`](https://github.com/bitnami/bitnami-docker-odoo/tree/master/14/debian-10/rootfs) folder of the container image repository.

Upgrades from previous versions require to specify `--set volumePermissions.enabled=true` in order for all features to work properly:

```console
$ helm upgrade odoo bitnami/odoo \
    --set odooPassword=$DISCOURSE_PASSWORD \
    --set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD \
    --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC \
    --set volumePermissions.enabled=true
```

Full compatibility is not guaranteed due to the amount of involved changes, however no breaking changes are expected aside from the ones mentioned above.

### To 17.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- Move dependency information from the *requirements.yaml* to the *Chart.yaml*
- After running `helm dependency update`, a *Chart.lock* file is generated containing the same structure used in the previous *requirements.lock*
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts
- This chart depends on the **PostgreSQL 10** instead of **PostgreSQL 9**. Apart from the same changes that are described in this section, there are also other major changes due to the master/slave nomenclature was replaced by primary/readReplica. [Here](https://github.com/bitnami/charts/pull/4385) you can find more information about the changes introduced

**Considerations when upgrading to this version**

- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3
- If you want to upgrade to this version from a previous one installed with Helm v3, it should be done reusing the PVC used to hold the PostgreSQL data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `odoo`):

> NOTE: Please, create a backup of your database before running any of those actions.

##### Export secrets and required values to update

```console
$ export ODOO_PASSWORD=$(kubectl get secret --namespace default odoo -o jsonpath="{.data.odoo-password}" | base64 --decode)
$ export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default odoo-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
$ export POSTGRESQL_PVC=$(kubectl get pvc -l app.kubernetes.io/instance=odoo,app.kubernetes.io/name=postgresql,role=master -o jsonpath="{.items[0].metadata.name}")
```

##### Delete statefulsets

Delete the Odoo deployment and delete the PostgreSQL statefulset. Notice the option `--cascade=false` in the latter:

```
$ kubectl delete statefulsets.apps --cascade=false odoo-postgresql
```

##### Upgrade the chart release

```console
$ helm upgrade odoo bitnami/odoo \
    --set odooPassword=$ODOO_PASSWORD \
    --set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD \
    --set postgresql.persistence.existingClaim=$POSTGRESQL_PVC
```

##### Force new statefulset to create a new pod for postgresql

```console
$ kubectl delete pod odoo-postgresql-0
```
Finally, you should see the lines below in the PostgreSQL container logs:

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

### To 18.0.0

This version standardizes the way of defining Ingress rules. When configuring a single hostname for the Ingress rule, set the `ingress.hostname` value. When defining more than one, set the `ingress.extraHosts` array. Apart from this case, no issues are expected to appear when upgrading.

### To 16.0.0

In this version the application version itself was bumped to the new major, odoo 14, and the database schemas where changed. Please refer to the [upstream upgrade process documentation](https://www.odoo.com/documentation/14.0/webservices/upgrade.html) in order to upgrade from the previous version.

### To 15.0.0

This major version includes two main changes:

- Major change in the PostgreSQL subchart labeling. Check [PostgreSQL Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/postgresql#900) for more information.
- Re-labeling so as to follow Helm label best practices (see [PR 3021](https://github.com/bitnami/charts/pull/3021))
- Adaptation to use common Bitnami chart standards. The following common elements have been included: extra volumes, extra volume mounts, common annotations and labels, pod annotations and labels, pod and container security contexts, affinity settings, node selectors, tolerations, init and sidecar containers, support for existing secrets, custom commands and arguments, extra env variables and custom liveness/readiness probes.

As a consequence, backwards compatibility from previous versions is not guaranteed during the upgrade. To upgrade to `9.0.0`, it should be done reusing the PVCs used to hold both the PostgreSQL and Odoo data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `odoo`):

> NOTE: Please, create a backup of your database before running any of those actions.

- Old version is up and running

  ```console
  $ helm ls
  NAME  NAMESPACE REVISION  UPDATED                               STATUS    CHART         APP VERSION
  odoo  default   1         2020-10-21 13:11:29.028263 +0200 CEST deployed  odoo-14.0.21  13.0.20201010

  $ kubectl get pods
  NAME                       READY   STATUS    RESTARTS   AGE
  odoo-odoo-984f954b9-tk8t8   1/1     Running   0          16m
  odoo-postgresql-0           1/1     Running   0          16m
  ```

- Export both database and Odoo credentials in order to provide them in the update

  ```console
  $ export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default odoo-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)

  $ export ODOO_PASSWORD=$(kubectl get secret --namespace default odoo-odoo -o jsonpath="{.data.odoo-password}" | base64 --decode)
  ```

- The upgrade to the latest (`15.X.X`) version is going to fail

  ```console
  $ helm upgrade odoo bitnami/odoo --set odooPassword=$ODOO_PASSWORD --set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD
  Error: UPGRADE FAILED: cannot patch "odoo-odoo" with kind Deployment: Deployment.apps "odoo-odoo" is invalid: spec.selector: Invalid value: v1.LabelSelector{MatchLabels:map[string]string{"app.kubernetes.io/instance":"odoo", "app.kubernetes.io/name":"odoo"}, MatchExpressions:[]v1.LabelSelectorRequirement(nil)}: field is immutable
  ```

- Delete both the statefulset and recplicaset (PostgreSQL and Odoo respectively). Notice the option `--cascade=false` for the former.

  ```console
  $ kubectl delete deployment.apps/odoo-odoo
  deployment.apps "odoo-odoo" deleted

  $ kubectl delete statefulset.apps/odoo-postgresql --cascade=false
  statefulset.apps "odoo-postgresql" deleted
  ```

- Now the upgrade works

  ```console
  $ helm upgrade odoo bitnami/odoo --set odooPassword=$ODOO_PASSWORD --set postgresql.postgresqlPassword=$POSTGRESQL_PASSWORD
  $ helm ls
  NAME  NAMESPACE REVISION  UPDATED                                STATUS   CHART       APP VERSION
  odoo  default   3         v2020-10-21 13:35:27.255118 +0200 CEST deployed odoo-15.0.0 13.0.20201010
  ```

- You can kill the existing PostgreSQL pod and the new statefulset is going to create a new one

  ```console
  $ kubectl delete pod odoo-postgresql-0
  pod "odoo-postgresql-0" deleted

  $ kubectl get pods
  NAME                        READY   STATUS    RESTARTS   AGE
  odoo-odoo-854b9cd5fb-282md   1/1     Running   0          9m12s
  odoo-postgresql-0            1/1     Running   0          7m19s
  ```

Please, note that without the --cascade=false both objects (statefulset and pod) are going to be removed and both objects will be deployed again with the helm upgrade command

### To 12.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17352 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is odoo:

```console
$ kubectl patch deployment odoo-odoo --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl patch deployment odoo-postgresql --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
