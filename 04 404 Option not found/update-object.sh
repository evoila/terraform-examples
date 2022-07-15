#/bin/bash
set -eu

ID=$(cat terraform.tfstate | jq -r '.resources[].instances[0].attributes.id')
PROFILE=$(curl -u "$NSXT_USERNAME:$NSXT_PASSWORD" -k https://$NSXT_MANAGER_HOST/api/v1/loadbalancer/application-profiles/$ID)

PAYLOAD=$(echo "$PROFILE" | jq '.response_header_size = 16192')

curl -u "$NSXT_USERNAME:$NSXT_PASSWORD" -k -H 'content-type: application/json' -X PUT https://$NSXT_MANAGER_HOST/api/v1/loadbalancer/application-profiles/$ID -d "$PAYLOAD"


