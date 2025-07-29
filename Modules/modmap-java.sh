#!/bin/bash
file="$1"
echo "📄 Java: $file"
echo -e "\n🔧 Methods:"
grep -E '^\s*(public|private|protected)?\s*(static)?\s*\w+\s+\w+\s*\(.*\)' "$file" | sed 's/^/ - /' || echo "None"
echo -e "\n📦 Imports:"
grep '^import ' "$file" || echo "None"

