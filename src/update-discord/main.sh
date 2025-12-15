#!/usr/bin/env bash

# Defined in my Obsidian vault
code_source_dirname="$(get_script_nth_dirname 2)"

if [[ ! $(type -t Maybe_Sudo) == function ]]; then
  source "$code_source_dirname/maybe-sudo.sh"
fi

deb_url="https://discord.com/api/download?platform=linux&format=deb"
temp_deb_file="$(mktemp -t discord-latest-XXXX.deb)"
curl -L -o "$temp_deb_file" "$deb_url"
Maybe_Sudo apt install "$temp_deb_file"
rm -f "$temp_deb_file"
