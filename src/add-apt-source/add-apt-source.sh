#!/bin/bash

# https://stackoverflow.com/a/77663806/11045433
script_dirname=$(dirname "$( readlink -f "${BASH_SOURCE[0]:-"$( command -v -- "$0" )"}" )")

if [[ ! $(type -t Maybe_Sudo) == function ]]; then
  source "$script_dirname/maybe-sudo.sh"
fi

declare -a required_variables=(
  "source_slug"
  "source_readable_name"
  "source_types"
  "source_uris"
  "source_suites"
  "source_components"
  "source_architectures"
  "source_signing_key"
  "source_pin_selector"
)
unset missing_required_variables
for required_variable in "${required_variables[@]}"; do
  if [ -n "${!required_variable}" ]; then continue; fi
  echo "required variable $required_variable is empty"
  missing_required_variables=true
done
if [ -v missing_required_variables ]; then
  echo "some required values are missing, exiting"
  exit 1
fi

apt_sources_dir="/etc/apt/sources.list.d"
source_file_path="$apt_sources_dir/$source_slug.sources"
apt_prefs_dir="/etc/apt/preferences.d"
prefs_file_path="$apt_prefs_dir/$source_slug.pref"

if [ -e "$source_file_path" ]; then
  echo "source file $source_file_path already exists, exiting"
  exit 1
fi

temp_source_file="$(mktemp -t XXXXXX.sources)"
cat >"$temp_source_file" <<EOL
X-Repolib-Name: $source_readable_name
Enabled: yes
Types: $source_types
URIs: $source_uris
Suites: $source_suites
Components: $source_components
Architectures: $source_architectures
Signed-By: $source_signing_key
EOL
Maybe_Sudo install -m 644 -o root -g root \
  -T "$temp_source_file" "$source_file_path"
rm "$temp_source_file"

temp_prefs_file="$(mktemp -t XXXXXX.pref)"
Maybe_Sudo cat >"$temp_prefs_file" <<EOL
Package: *
Pin: $source_pin_selector
Pin-Priority: 100
EOL
Maybe_Sudo install -m 644 -o root -g root \
  -T "$temp_prefs_file" "$prefs_file_path"
rm "$temp_prefs_file"
