#! /bin/bash -e

# Allow executing jb steps in subshell to contain path change in subshell even if sourced
# first argument is the dir to setup in, second is the k8s to setup
setup() {

  cd "$1"

  if [ ! -f "jsonnetfile.json" ]; then
    jb init
  fi

  jb install "https://github.com/jsonnet-libs/k8s-libsonnet/${2}@main"

  echo "import \"../vendor/${2}/main.libsonnet\"" > ${1}/lib/k.libsonnet

}

__SCRIPT_DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

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

#Run function in subshell
(setup "${__SCRIPT_DIR}" "${__VERSION}")

echo "Setup k.libsonnet for k8s version $__VERSION. To use it, append $__SCRIPT_DIR/lib to your jpath or source this script"

# Enable easy sourcing of this script
export JSONNET_PATH="$JSONNET_PATH:$__SCRIPT_DIR/lib"
