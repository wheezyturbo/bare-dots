#!/bin/sh
# Emergency: strip all status2d color codes from scripts
# Run this if DWM crashes with colored output
cd "$(dirname "$0")"
for f in sb-*; do
    sed -i 's/\^c#[0-9A-Fa-f]\{6\}\^//g; s/\^c%s\^//g; s/\^d\^//g' "$f"
done
echo "Color codes stripped from all scripts."
