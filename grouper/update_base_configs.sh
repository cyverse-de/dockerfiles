#!/bin/bash

set -e

function get_hierarchy_additions() {
    local file="$1"
    grep -F ".hierarchy" "$file" \
        | perl -pe 's/.*= //' \
        | perl -pe 's/, database:grouper//' \
        | perl -pe 's/[^, ]+base[^, ]+, //' \
        | perl -pe 's{classpath:}{file:/etc/grouper/}g'
}

for file in $(grep -Fl ".hierarchy" classes/*.properties); do
    dos2unix "$file" 2> /dev/null
    additions=$(get_hierarchy_additions "$file")
    perl -pi -e "s{(.*[.]hierarchy.*)}{\1, $additions}" "$file"
done
