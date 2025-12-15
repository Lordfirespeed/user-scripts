#!/bin/bash

# Defined in my Obsidian vault
code_source_dirname="$(get_script_nth_dirname 2)"

owner_slug=${1:?missing owner_slug argument}
repo_slug=${2:?missing repo_slug argument}

source "$code_source_dirname/add-apt-source/get-launchpad-ppa-info.sh" "$owner_slug" "$repo_slug"
"$code_source_dirname/add-apt-source/add-apt-source.sh"
