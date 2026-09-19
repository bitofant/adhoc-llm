#!/usr/bin/env bash
# Report runtime state: up (0) / down (1) / starting (2).
set -euo pipefail
source "$(dirname "$0")/scripts/lib.sh"
load_config
dispatch status "$@"
