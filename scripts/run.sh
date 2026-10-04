#!/usr/bin/env bash
set -euo pipefail

if command -v python3 >/dev/null 2>&1 && python3 --version 2>&1 | grep -q "Python 3"; then
    python3 app.py
else
    py app.py
fi