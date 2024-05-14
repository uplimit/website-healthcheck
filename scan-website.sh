#!/bin/bash

website_url=$1
scan_text=$2
maximum_retries=$3
duration_between_retries=$4

# Initialize retry counter
retry_count=0

check_website() {
    status_code=$(curl --silent --location --head --output /dev/null --write-out "%{http_code}" "${website_url}")

    if [ "${status_code}" != "200" ]; then
        echo "${website_url} is unreachable or returned non-200 status (${status_code})" >&2
        return 1
    fi

    if ! curl --silent --location "${website_url}" | grep --quiet --ignore-case "${scan_text}"; then
        echo "${scan_text} was not found on ${website_url}" >&2
        return 1
    fi

    return 0
}


# Loop to retry the check up to maximum_retries times
while [ "${retry_count}" -lt "${maximum_retries}" ]; do
    if check_website; then
        echo "${scan_text} was found on ${website_url}" >&2
        echo "Website check passed"
        exit 0
    else
        echo "Retrying... (${retry_count}/${maximum_retries})" >&2
        retry_count=$((retry_count + 1))
        sleep "${duration_between_retries}"  # Optional: Add a small delay before retrying
    fi
done

# If we exit the loop, all retries have been exhausted
echo "Max retries reached, exiting with failure" >&2
exit 1
