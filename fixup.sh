#!/bin/bash

# Loop through all .md files recursively in the ./content directory
for file in $(find ./content -type f -name "*.md"); do
    # Check if the file already starts with a YAML header
    if grep -q '^---' "$file"; then
        # Remove the existing header
        sed -n '/^---/,$p' "$file" > temp && mv temp "$file"
        # Correcting sed command to properly remove existing YAML headers:
        sed -i '/^---/,/^---/d' "$file"
    fi

    # Get the first header line from the file (excluding any existing YAML headers)
    TITLE=$(tail -n +2 "$file" | head -n 100 | grep -m 1 '^#' | sed 's/^# *//')

    # Define the header content dynamically using the first header
    HEADER="---
title: \"$TITLE\"
render_with_liquid: false
---
"

    # Use tee to redirect output to file, cat to keep original content, and echo to add the header
    echo "$HEADER" > temp.md
    cat "$file" >> temp.md
    mv temp.md "$file"
done
