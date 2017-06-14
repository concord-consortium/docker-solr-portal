#!/bin/bash
set +e

echo
echo "Re-indexing sunspot..."
echo

curl -G -v "${SERVICE_API_ENDPOINT}" --data-urlencode "service_api_key=${SERVICE_API_KEY}"

echo
echo
echo "Re-index completed."
echo

