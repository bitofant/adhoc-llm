# Local setup
Instructions for an AI agent setting up a fresh clone on a new machine. Do each step, then verify it.

## 1. Repo sanity
```sh
./status.sh
```
Expect a "not implemented" message from the provider backend, exit 64. That means
config loading and dispatch work. Any *other* error is a real problem.

## 2. Tooling
| need | check | notes |
|---|---|---|
| bash 4+ | `bash --version` | scripts use `BASH_SOURCE`, arrays |
| aws cli v2 | `aws sts get-caller-identity` | only for `PROVIDER=aws` |
| tailscale *or* ssh | `tailscale status` | remote API binds localhost; tunnel is the only path in |
| local fallback LLM | `curl -s $LOCAL_FALLBACK_URL/models` | ollama or similar, used when no remote runtime is up |

## 3. Select a model
Edit `config/active.env` → `MODEL=`, matching a file in `config/models/`.
Then fill in the empty provider fields in that model's env file (for AWS: region,
AMI id, S3 bucket). `./status.sh` will tell you what's missing.

## 4. Provider one-time setup
Per provider, done once per account, not per clone:
- AWS: `docs/providers/aws-g7e.md` § One-time setup
- RunPod: `docs/providers/runpod.md`

## Not yet set up
- the local proxy (`docs/architecture.md`) — no implementation yet
- no provider backend is implemented, so nothing can actually be launched
