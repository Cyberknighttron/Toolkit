#!/bin/bash

file="$1"

# Check if file exists
if [[ ! -f "$file" ]]; then
    echo "[!] File not found: $file"
    exit 1
fi

# Get file extension
ext="${file##*.}"
start_time=$(date +%s%N)

# Run based on extension
case "$ext" in
    py)
        python3 "$file"
        ;;
    sh)
        bash "$file"
        ;;
    c)
        temp_out="/tmp/quickrun_c_exec"
        gcc "$file" -o "$temp_out" && "$temp_out"
        rm -f "$temp_out"
        ;;
    cpp)
        temp_out="/tmp/quickrun_cpp_exec"
        g++ "$file" -o "$temp_out" && "$temp_out"
        rm -f "$temp_out"
        ;;
    js)
        node "$file"
        ;;
    java)
        class=$(basename "$file" .java)
        javac "$file" && java "$class"
        rm -f "$class.class"
        ;;
    rs)
        temp_out="/tmp/quickrun_rs_exec"
        rustc "$file" -o "$temp_out" && "$temp_out"
        rm -f "$temp_out"
        ;;
    *)
        echo "[!] Unsupported file type: $ext"
        exit 2
        ;;
esac

end_time=$(date +%s%N)
elapsed_ns=$((end_time - start_time))
elapsed_ms=$((elapsed_ns / 1000000))
echo ""
echo "⏱️  Executed in ${elapsed_ms} ms"
