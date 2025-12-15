#!/bin/bash

export source_slug="nginx"
export source_readable_name="NGINX mainline"
export source_types="deb deb-src"
export source_uris="http://nginx.org/packages/mainline/ubuntu"
export source_suites="$(lsb_release -cs)"
export source_components="main"
export source_architectures="amd64"
export source_signing_key="/usr/share/keyrings/nginx-archive-keyring.gpg"
export source_pin_selector="origin nginx.org"
