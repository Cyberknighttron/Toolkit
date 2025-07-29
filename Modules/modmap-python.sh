#!/bin/bash

file="$1"
echo "📂 ModMap for Python file: $file"

echo "🔧 Functions:"
grep -E '^def ' "$file" | sed 's/def / - /' | sed 's/(.*//' || echo "None"

echo "📦 Imports:"
grep -E '^import |^from ' "$file" || echo "None"

