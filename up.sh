#!/usr/bin/env bash
# Bring up the selected model's remote runtime. Blocks until it serves.
# Model selection: config/active.env
set -euo pipefail
source "$(dirname "$0")/scripts/lib.sh"
load_config
echo "model=$MODEL provider=$PROVIDER" >&2
dispatch up "$@"
