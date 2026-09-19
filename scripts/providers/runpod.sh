#!/usr/bin/env bash
# RunPod backend. Contract: docs/architecture.md. Notes: docs/providers/runpod.md
#
# NOT IMPLEMENTED. No model has been selected for RunPod yet.
set -euo pipefail

verb="${1:-}"

case "$verb" in
    up|down|status|endpoint)
        echo "runpod backend: '$verb' not implemented yet. See docs/providers/runpod.md" >&2
        exit 64
        ;;
    *) echo "usage: $0 {up|down|status|endpoint}" >&2; exit 64 ;;
esac
