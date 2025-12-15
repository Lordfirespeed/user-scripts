#!/bin/bash

# https://stackoverflow.com/a/77663806/11045433
script_dirname=$(dirname "$( readlink -f "${BASH_SOURCE[0]:-"$( command -v -- "$0" )"}" )")

if [[ ! $(type -t Import_Signing_Key_From_Keyserver) == function ]]; then
  source "$script_dirname/import-signing-keys.sh"
fi

owner_slug=${1:?missing owner_slug argument}
repo_slug=${2:?missing repo_slug argument}

export source_slug="ppa:$owner_slug:$repo_slug"

ppa_metadata_file=$(mktemp -t "XXXXXX.json")
curl -sH "Accept: application/json" \
"https://api.launchpad.net/1.0/~$owner_slug/+archive/$repo_slug" \
  -o "$ppa_metadata_file"
IFS=$'\n' read -rd '' \
  ppa_displayname \
  ppa_signing_key_fingerprint \
  < <(jq -r ".displayname, .signing_key_fingerprint" "$ppa_metadata_file")

export source_readable_name="$ppa_displayname"
export source_types="deb deb-src"
export source_uris="https://ppa.launchpadcontent.net/$owner_slug/$repo_slug/ubuntu"
export source_suites="$(lsb_release -cs)"
export source_components="main"
export source_architectures="amd64"
export source_pin_selector="release o=LP-PPA-$owner_slug-$repo_slug"
rm $ppa_metadata_file

export source_signing_key="$(Import_Signing_Key_From_Keyserver "$ppa_signing_key_fingerprint")"
