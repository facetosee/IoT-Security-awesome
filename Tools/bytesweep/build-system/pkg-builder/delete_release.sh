#!/bin/bash

bytesweep_project_id="12398338"
read -p "gitlab token: " gitlab_token
read -p "tag name: " tag_name

curl --request DELETE --header "PRIVATE-TOKEN: $gitlab_token" "https://gitlab.com/api/v4/projects/$bytesweep_project_id/releases/$tag_name"
