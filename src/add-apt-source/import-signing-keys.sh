#!/bin/bash

# Defined in my Obsidian vault
code_source_dirname="$(get_script_nth_dirname 2)"

if [[ ! $(type -t Maybe_Sudo) == function ]]; then
  source "$code_source_dirname/maybe-sudo.sh"
fi

function Import_Signing_Key_From_Keyserver {
  key_fingerprint=${1:?missing key_fingerprint argument}
  key_server=${2:-"keyserver.ubuntu.com"}
  key_destination_dir="/usr/share/keyrings/$key_server"

  temp_keyring=$(mktemp -t XXXXXX.gpg)
  gpg --homedir $(mktemp -d) \
    --no-default-keyring \
    --keyring "$temp_keyring" \
    --keyserver "$key_server" \
    --recv-keys "$key_fingerprint"

  key_slug="$(gpg --show-keys "$temp_keyring" | python3 "$code_source_dirname/add-apt-source/extract_key_slug.py")"
  key_destination="$key_destination_dir/$key_slug.gpg"

  Maybe_Sudo mkdir -p "$key_destination_dir"
  Maybe_Sudo install -m 644 -o root -g root \
    -T "$temp_keyring" "$key_destination"
  echo "$key_destination"
}
export -f Import_Signing_Key_From_Keyserver

function Import_Signing_Key_From_Url {
  key_url=${1:?missing key_url argument}
  key_slug=${2:?missing key_slug argument}
  key_destination_dir="/usr/share/keyrings"

  temp_keyring=$(mktemp -t XXXXXX.gpg)
  curl --fail "$key_url" | gpg --homedir $(mktemp -d) \
    --no-default-keyring \
    --keyring "$temp_keyring" \
    --import

  key_destination="$key_destination_dir/$key_slug.gpg"
  Maybe_Sudo mkdir -p "$key_destination_dir"
  Maybe_Sudo install -m 644 -o root -g root \
    -T "$temp_keyring" "$key_destination"
  echo "$key_destination"
}
export -f Import_Signing_Key_From_Url
