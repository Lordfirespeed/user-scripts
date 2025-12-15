#!/bin/bash

# https://stackoverflow.com/a/77663806/11045433
script_dirname=$(dirname "$( readlink -f "${BASH_SOURCE[0]:-"$( command -v -- "$0" )"}" )")

owner_slug=${1:?missing owner_slug argument}
repo_slug=${2:?missing repo_slug argument}

source "$script_dirname/get-launchpad-ppa-info.sh" "$owner_slug" "$repo_slug"
"$script_dirname/add-apt-source.sh"
