#!/bin/bash
file="$1"
echo "📄 C: $file"
echo -e "\n🔧 Functions:"
grep -E '^[a-zA-Z_][a-zA-Z0-9_]* [a-zA-Z_][a-zA-Z0-9_]*\(.*\)' "$file" | sed 's/^/ - /' || echo "None"
echo -e "\n📦 Includes:"
grep '^#include' "$file" || echo "None"

