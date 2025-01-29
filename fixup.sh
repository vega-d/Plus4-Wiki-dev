#!/bin/bash

# Loop through all .md files recursively in the ./content directory
for file in $(find ./content -type f -name "*.md"); do
    # Get the first header line
    TITLE=$(head -n 100 "$file" | grep -m 1 '^#' | sed 's/^# *//')

    # Define the header content dynamically using the first header
    HEADER="
---
title: \"$TITLE\"
render_with_liquid: false
---
"

    # Use tee to redirect output to file, cat to keep original content, and echo to add the header
    echo "$HEADER" > temp.md
    cat "$file" >> temp.md
    mv temp.md "$file"
done
