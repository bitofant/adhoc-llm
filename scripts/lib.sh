#!/usr/bin/env bash
# Shared config loading. Source this, don't execute it.
# Exports MODEL, PROVIDER and everything from the selected model's env file.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export REPO_ROOT

load_config() {
    local active="$REPO_ROOT/config/active.env"
    [[ -f "$active" ]] || { echo "missing $active" >&2; return 1; }
    # env wins over config file: MODEL=other ./up.sh
    local model_override="${MODEL:-}"
    set -a
    # shellcheck disable=SC1090
    source "$active"
    [[ -n "$model_override" ]] && MODEL="$model_override"
    [[ -n "${MODEL:-}" ]] || { echo "MODEL not set in $active" >&2; set +a; return 1; }
    local model_env="$REPO_ROOT/config/models/$MODEL.env"
    [[ -f "$model_env" ]] || { echo "unknown model '$MODEL': no $model_env" >&2; set +a; return 1; }
    # shellcheck disable=SC1090
    source "$model_env"
    set +a
    [[ -n "${PROVIDER:-}" ]] || { echo "PROVIDER not set in $model_env" >&2; return 1; }
}

# dispatch <verb> [args...] -> scripts/providers/$PROVIDER.sh
dispatch() {
    local backend="$REPO_ROOT/scripts/providers/$PROVIDER.sh"
    [[ -x "$backend" ]] || { echo "no backend for provider '$PROVIDER' at $backend" >&2; return 1; }
    "$backend" "$@"
}
