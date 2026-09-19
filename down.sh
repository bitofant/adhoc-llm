#!/usr/bin/env bash
# Tear down all billable compute for the selected model. Idempotent.
set -euo pipefail
source "$(dirname "$0")/scripts/lib.sh"
load_config
dispatch down "$@"
