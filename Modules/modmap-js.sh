#!/bin/bash
file="$1"
echo "📄 JavaScript: $file"
echo -e "\n🔧 Functions:"
grep -E '^function |^[a-zA-Z0-9_]+\s*=\s*function|^const\s+[a-zA-Z0-9_]+\s*=\s*\(' "$file" | sed 's/^/ - /' || echo "None"
echo -e "\n📦 Imports:"
grep -E '^import |^require\(' "$file" || echo "None"

