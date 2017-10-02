#!/bin/sh
set -e -u -o pipefail

. "$(dirname "$0")"/terraform-common.sh
run_awscli "$@"
