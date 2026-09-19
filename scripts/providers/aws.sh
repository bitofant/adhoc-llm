#!/usr/bin/env bash
# AWS g7e spot backend. Contract: docs/architecture.md. Plan: docs/providers/aws-g7e.md
#
# NOT IMPLEMENTED. Blocked on the one-time setup (GPU/spot quota, weights in S3,
# baked AMI). Implementing before that is done would produce untestable code.
set -euo pipefail

verb="${1:-}"

not_implemented() {
    cat >&2 <<EOF
aws backend: '$verb' not implemented yet.

Prerequisites, in order (docs/providers/aws-g7e.md):
  1. GPU quota increase for G-family, including spot
  2. weights -> S3 (hashes verified), kernel cache warmed
  3. AMI baked with NVIDIA driver + SGLang image
  4. fill in AWS_REGION / AWS_AMI_ID / AWS_S3_BUCKET in config/models/\$MODEL.env

Do not launch anything unattended before the idle watchdog and billing alarm exist.
EOF
    exit 64
}

case "$verb" in
    up|down|status|endpoint) not_implemented ;;
    *) echo "usage: $0 {up|down|status|endpoint}" >&2; exit 64 ;;
esac
