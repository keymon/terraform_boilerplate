#!/bin/sh
set -e -u -o pipefail

cd "$(dirname "$0")"

. ./terraform-common.sh
[ -f ./terraform-vars.sh ] && . ./terraform-vars.sh

case "${1:-}" in
  init-backend)
    init_terraform_backend
    ;;
  init)
    init_terraform_backend
    run_terraform init
    run_terraform get
    ;;
  *)
    run_terraform "$@"
    ;;
esac
