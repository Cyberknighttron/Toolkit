#!/bin/bash
file="$1"
echo "📄 Shell Script: $file"
echo -e "\n🔧 Functions:"
grep -E '^[a-zA-Z0-9_]+\(\)\s*\{' "$file" | sed 's/^/ - /' || echo "None"
echo -e "\n📦 Sourced Scripts:"
grep -E 'source |\. ' "$file" || echo "None"

