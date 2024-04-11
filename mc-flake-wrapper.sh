#!/usr/bin/env bash

# Define the path for the temporary file.
# Using TMPDIR for portability, defaulting to /tmp if not set.
temp_file="${TMPDIR:-/tmp}/mc-last-dir.$$"

# Function to clean up the temporary file upon exit.
cleanup() {
    if [[ -f "$temp_file" ]]; then
        rm -f "$temp_file"
    fi
}
trap cleanup EXIT

# Run Midnight Commander with the custom logic to write the last directory to the temp file.
# Assuming the path to MC is passed via $1 for simplicity; adjust as needed.
"$1" --last-dir "$temp_file"

# If MC wrote the last directory to the temp file, change to that directory.
if [[ -f "$temp_file" ]]; then
    last_dir=$(cat "$temp_file")
    cd "$last_dir" || exit
fi
