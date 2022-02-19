#! /bin/bash

SCRIPT_DIR=$(realpath ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname $SCRIPT_DIR)

if [ ! -f "jsonnetfile.json" ]; then
  jb init
fi

if [ -z "${1+x}" ]; then
  # Automatically set to version of server pointed to by current kubeconfig
  VERSION=$(kubectl version -o yaml | yq '[.serverVersion.major, .serverVersion.minor ] | join(".")')
else
  if [[ $1 =~ v?([0-9]+\.[0-9]+)(\.[0-9]+)? ]]; then
    VERSION=${BASH_REMATCH[1]}
  else
    echo "Version string must match the regexp 'v?([0-9]+\.[0-9]+)(\.[0-9]+)?'"
    exit 1
  fi
fi

jb install "https://github.com/jsonnet-libs/k8s-libsonnet/${VERSION}@main"

echo "import \"./submodule/${VERSION}/main.libsonnet\"" > lib/k.libsonnet

echo "Setup k.libsonnet for k8s version $VERSION. To use it, append $SCRIPT_DIR/lib to your jpath or source this script"

# Enable easy sourcing of this script
JSONNET_PATH="$JSONNET_PATH:$SCRIPT_DIR/lib"
unset SCRIPT_DIR
unset VERSION