#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 file1.txt [file2.txt ...]"
    exit 1
fi

if ! command -v pv >/dev/null 2>&1; then
    echo "Error: pv is required for progress display"
    echo "Install with: sudo apt install pv"
    exit 1
fi

for input in "$@"; do
    if [[ ! -f "$input" ]]; then
        echo "Skipping (not a file): $input"
        continue
    fi

    output="${input%.txt}.nft"
    tmp="$(mktemp)"

    echo "elements = {" > "$tmp"

    # pv shows progress based on file size
    pv "$input" | grep -Ev '^\s*(#|$)' | while read -r line; do
        cidr="$(echo "$line" | tr -d '[:space:]')"

        # IPv4 CIDR
        if [[ "$cidr" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}/([0-9]|[1-2][0-9]|3[0-2])$ ]]; then
            echo "    $cidr," >> "$tmp"
            continue
        fi

        # IPv6 CIDR
        if [[ "$cidr" =~ : ]] && [[ "$cidr" =~ / ]]; then
            echo "    $cidr," >> "$tmp"
            continue
        fi
    done

    echo "}" >> "$tmp"
    mv "$tmp" "$output"

    echo "Converted: $input -> $output"
done
