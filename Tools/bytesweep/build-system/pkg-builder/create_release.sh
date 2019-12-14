#!/bin/bash

#bytesweep_ubuntu_18=$1
#bytesweep_centos_7=$2
#bytewalk_ubuntu_18=$3
#bytewalk_centos_7=$4
#bs_name_ubuntu_18=$(basename $bytesweep_ubuntu_18)
#bs_name_centos_7=$(basename $bytesweep_centos_7)
#bw_name_ubuntu_18=$(basename $bytesweep_ubuntu_18)
#bw_name_centos_7=$(basename $bytesweep_centos_7)
#
#if [ $# -ne 4 ]; then
#	echo "usage: $0 <bytesweep_ubuntu_18> <bytesweep_centos_7> <bytewalk_ubuntu_18> <bytewalk_centos_7>"
#	exit 1
#fi
bytesweep_project_id="12398338"
bytesweep_version=$(cat /builds/bytesweep/version)
tag_name="v$bytesweep_version"
release_name="v $bytesweep_version"
release_description="bytesweep v$bytesweep_version release"

read -p "gitlab token: " gitlab_token

# upload artifacts
artifacts=()
for f in $(ls /artifacts/)
do
	filename="/artifacts/$f"
	echo $filename
	resp=$(curl --request POST --header "PRIVATE-TOKEN: $gitlab_token" https://gitlab.com/api/v4/projects/$bytesweep_project_id/uploads --form "file=@$filename")
	url=$(python3 -c "import json;resp='$resp';print(json.loads(resp)['url'])")
	artifact="$f#$url"
	artifacts+=($artifact)
done

links=""
for i in "${artifacts[@]}"
do
	name=$(echo $i | awk -F# '{print $1}')
	url=$(echo $i | awk -F# '{print $2}')
    links="$links{\"name\":\"$name\",\"url\":\"https://gitlab.com/bytesweep/bytesweep$url\"},"
done
links_final=${links::-1}
echo $links_final

# create release
curl --header 'Content-Type: application/json' --header "PRIVATE-TOKEN: $gitlab_token" \
     --data "{ \"name\": \"$release_name\", \"tag_name\": \"$tag_name\", \"description\": \"$release_description\", \"assets\": { \"links\": [$links_final] } }" \
     --request POST https://gitlab.com/api/v4/projects/$bytesweep_project_id/releases
