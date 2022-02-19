# Simple Setup Helper for `k8s-libsonnet` & `k.libsonnet`

Setup the correct k8s-libsonnet & k.libsonnet easily without Tanka!

If you develop or use jsonnet libraries for kubernetes you will often need an easy way to put the correct version of k8-slibsonnet (via k.libsonnet) on the JPath. Tanka does this automatically during init, however this also imposes additional restrictions on your project, which you might not want, especially if you only need the import for your IDE plugin to work with a non-Tanka project.

# Quick Usage

```bash
# Automatically setup for your cluster (needs bash, jb, yq, kubectl, and valid KUBECONFIG)
source ./setup-k8s-libsonnet.sh

# Setup for specific k8s version (needs bash, jb)
source ./setup-k8s-libsonnet.sh 1.21

# Only install/switch version, don't touch env vars
./setup-k8s-libsonnet.sh 1.22
```

This will setup the correct `k.libsonnet` in the `lib` folder, and put `$PWD/lib` on the jpath by appending to the JSONNET_PATH env variable in the current shell. Alternatively, specifiy the absolute path to `lib/` as part of the jpath manually in your IDE and all cli calls. If the jpath is setup correctly, you will only need to invoke the script again if you want to switch k8s api-versions.
