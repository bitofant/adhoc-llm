#!/usr/bin/env bash
# Non-interactive coding-agent call.
# Usage: scripts/agent.sh "prompt"  |  cmd | scripts/agent.sh "instructions"
# Args + stdin are passed through; stdout = final response.
# Uses pi if installed, else Claude Code. Both run tools without permission prompts.
set -euo pipefail

if command -v pi >/dev/null 2>&1; then
    exec pi -p --no-session "$@"
elif command -v claude >/dev/null 2>&1; then
    exec claude -p --no-session-persistence --dangerously-skip-permissions "$@"
else
    echo "agent.sh: neither pi nor claude found on PATH" >&2
    exit 127
fi
