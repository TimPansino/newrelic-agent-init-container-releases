#!/bin/bash

GITHUB_OUTPUT=/dev/null
release_tag="v1.2.3_python"

version_array=()
version_names=("full" "major" "minor" "patch" "build" "subbuild")
tags=()
add_outputs_for_version_len() {
    version_len=$1
    version_name="${version_names[version_len]}"
    version_priority=$(( 1010 - ${version_len} ))
    if [[ version_len -le ${#version_array[@]} ]]; then
        sliced_version=$(echo ${version_array[@]} | sed "s/ /./g")
        tags+="type=raw,value=${sliced_version},priority=${version_priority}"
    fi
}


output() {
    echo "$1=$2" | tee -a $GITHUB_OUTPUT
}

# Get container version from release tag by removing v prefix and language suffix
# release_tag=${{ github.ref_name }}
container_version=$(echo ${release_tag} | sed -e "s/^v//g" -e "s/_[a-zA-Z]*//g")

# Split agent version to array
IFS="$IFS."; for i in ${container_version}; do version_array+=($i); done; IFS="${IFS:0:3}"

# Add version outputs for each version length
for i in {1..5}; do add_outputs_for_version_len $i; done

# Agent version strips the last build number off the end
output agent_version $(echo ${version_array[@]:0:$((${#version_array[@]} - 1))} | sed "s/ /./g")

# Join tags into single string
output tags $()