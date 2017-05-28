# Before you begin

### Setup a Kubernetes Cluster

The quickest way to setup a Kubernetes cluster is with [Google Container Engine](https://cloud.google.com/container-engine/) (GKE) using [these instructions](https://cloud.google.com/container-engine/docs/before-you-begin).

Finish up by creating a cluster:

```bash
$ gcloud container clusters create my-cluster
```

The above command creates a new cluster named `my-cluster`. You can name the cluster according to your preferences.

> For setting up Kubernetes on other cloud platforms or bare-metal servers refer to the Kubernetes [getting started guide](http://kubernetes.io/docs/getting-started-guides/).

### Install Helm

Helm is a tool for managing Kubernetes charts. Charts are packages of pre-configured Kubernetes resources.

To install Helm, refer to the [Helm install guide](https://github.com/kubernetes/helm#install) and ensure that the `helm` binary is in the `PATH` of your shell.

### Using Helm

Once you have installed the Helm client and initialized the Tiller server, you can deploy a Bitnami Helm Chart into a Kubernetes cluster.

> Run `helm init` to initialize the Tiller server.

Please refer to the [Quick Start guide](https://github.com/kubernetes/helm/blob/master/docs/quickstart.md) if you wish to get running in just a few commands, otherwise the [Using Helm Guide](https://github.com/kubernetes/helm/blob/master/docs/using_helm.md) provides detailed instructions on how to use the Helm client to manage packages on your Kubernetes cluster.

Useful Helm Client Commands:
* View available charts: `helm search`
* Install a chart: `helm install stable/<package-name>`
* Upgrade your application: `helm upgrade`
