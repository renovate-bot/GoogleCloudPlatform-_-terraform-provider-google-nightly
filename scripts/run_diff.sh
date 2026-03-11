#!/bin/bash
# Copyright IBM Corp. 2014, 2026
# SPDX-License-Identifier: MPL-2.0

set -e
set -x
if [ -z "$1" ]; then
  echo "Must provide 1 argument - name of resource to diff, e.g. 'google_compute_forwarding_rule'"
  exit 1
fi

function cleanup() {
  go mod edit -dropreplace=github.com/hashicorp/terraform-provider-clean-google-nightly
  go mod edit -droprequire=github.com/hashicorp/terraform-provider-clean-google-nightly
}

trap cleanup EXIT
if [[ -d ~/go/src/github.com/hashicorp/terraform-provider-clean-google-nightly ]]; then
  pushd ~/go/src/github.com/hashicorp/terraform-provider-clean-google-nightly
  git clean -fdx
  git reset --hard
  git checkout main
  git pull
  popd
else
  mkdir -p ~/go/src/github.com/hashicorp
  git clone https://github.com/hashicorp/terraform-provider-google-nightly ~/go/src/github.com/hashicorp/terraform-provider-clean-google-nightly
fi


go mod edit -require=github.com/hashicorp/terraform-provider-clean-google-nightly@v0.0.0
go mod edit -replace github.com/hashicorp/terraform-provider-clean-google-nightly=$(realpath ~/go/src/github.com/hashicorp/terraform-provider-clean-google-nightly)
go run scripts/diff.go --resource $1 --verbose
