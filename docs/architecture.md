# Architecture

```
client ──> local proxy (PROXY_PORT) ──> remote runtime via tunnel   [when up]
                                   └──> LOCAL_FALLBACK_URL          [when down]
```

Clients only ever know the proxy address. Nothing reconfigures when the remote
runtime comes and goes.

## Lifecycle contract

`up.sh` / `down.sh` / `status.sh` read `config/active.env`, source
`config/models/$MODEL.env`, then dispatch to `scripts/providers/$PROVIDER.sh <verb>`.

Backends implement:

| verb | must do | stdout |
|---|---|---|
| `up` | provision, load weights, start server, block until smoke check passes | endpoint URL |
| `down` | terminate everything billable. idempotent. | — |
| `status` | `up` / `down` / `starting`, exit 0/1/2 respectively | state word |
| `endpoint` | current base URL, or exit 1 | URL |

Rules for every backend:
- `down` must be safe to call when nothing is running, and must leave **zero** billable
  compute. Storage that intentionally persists is listed in the provider doc.
- `up` is not done until a real completion round-trips. Provisioned ≠ serving.
- the server binds localhost only; reachability is via tunnel (Tailscale or SSH).
- an idle watchdog runs server-side, so a forgotten session dies without the laptop.

## Privacy invariants
- weights and prompts stay on infrastructure the user controls
- server request logging off
- object storage encrypted
- no inference traffic to third-party APIs, except an explicitly chosen ZDR fallback

## Status
Contract is defined; no backend implements it yet. See `docs/providers/`.
