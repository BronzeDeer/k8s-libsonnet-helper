#! /bin/bash

__SCRIPT_DIR=$(realpath ${BASH_SOURCE[0]})
__SCRIPT_DIR=$(dirname $__SCRIPT_DIR)


cd ${__SCRIPT_DIR}

if [ ! -f "jsonnetfile.json" ]; then
  jb init
fi

if [ -z "${1+x}" ]; then
  # Automatically set to version of server pointed to by current kubeconfig
  __VERSION=$(kubectl version -o yaml | yq '[.serverVersion.major, .serverVersion.minor ] | join(".")')
else
  if [[ $1 =~ v?([0-9]+\.[0-9]+)(\.[0-9]+)? ]]; then
    __VERSION=${BASH_REMATCH[1]}
  else
    echo "Version string must match the regexp 'v?([0-9]+\.[0-9]+)(\.[0-9]+)?'"
    exit 1
  fi
fi

jb install "https://github.com/jsonnet-libs/k8s-libsonnet/${__VERSION}@main"

echo "import \"../vendor/${__VERSION}/main.libsonnet\"" > ${__SCRIPT_DIR}/lib/k.libsonnet

echo "Setup k.libsonnet for k8s version $__VERSION. To use it, append $__SCRIPT_DIR/lib to your jpath or source this script"

# Enable easy sourcing of this script
JSONNET_PATH="$JSONNET_PATH:$__SCRIPT_DIR/lib"
unset __SCRIPT_DIR
unset __VERSION
