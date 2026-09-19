# Ad-Hoc LLM
- always keep CLAUDE.md accurate and complete
- in .md files use terse language, assume the reader is a highly capable AI agent like yourself, be mindful of their context window

### Goal
- run frontier open-weight LLMs on rented GPUs, on demand, for short sessions (tens of minutes to a few hours)
- set up everything so it can be used locally
- local proxy forwards to the remote LLM while it's up, else to a local LLM
- drivers, in order:
  1. **privacy** — prompts never reach a third-party inference provider
  2. **curiosity** — serving stacks, hardware, what it takes to run these things
  3. **cost** — hobby budget. idle cost ~0 is mandatory; active $/hr must stay defensible, but this is not a cost-optimization project

### Providers
Pluggable, selected per model in config. See `docs/providers/`.
- `runpod` — cheap, fast spin-up, small/medium models. original target.
- `aws` — big-VRAM boxes (g7e spot) for models that don't fit anywhere cheap.

Self-hosting is generally *more* expensive per token than a ZDR API. That's accepted: see Goal. Record the comparison in each model doc so the tradeoff stays explicit.

### Details
- runtime should be optimized for 1-5 requests in parallel tops
- we can make do with reduced context windows if it puts us under a threshold so we can run on a significantly cheaper machine
- we don't really want a heavily quantized model variant
- whenever considering quantization, either model or kv cache, you need to show that performance does not meaningfully degrade and you need user signoff
- we'll try out a couple of models, e.g. DeepSeek V4.1 Flash, GLM 5.3, Qwen3.8-flash-next, Kimi K3, and it's important to codify the setup and hardware to run on
- the need for custom commands should be absolutely minimized. create shell scripts for common actions, rely on config files e.g. for model selection, setup per model etc
- every remote runtime needs an idle watchdog and a billing alarm before it is ever launched unattended
- numbers copied from planning sessions (prices, throughput, instance specs) are **unverified** until checked against the provider. mark them as such in docs
- use `docs/` for documentation: `docs/models/<model>.md` for decisions and findings per model, `docs/providers/<provider>.md` per provider
- put main scripts intended to be used by the user at the top level directory of this repo; use `scripts/` for scripts called by other scripts or for agent use
- local setup of a fresh clone: `docs/setup.md`
- scripts can call a coding agent via `scripts/agent.sh` (uses pi, falls back to claude, both without permission prompts). args + stdin passed through; stdout = final response. never call a harness (`pi`, `claude`, ...) directly
  - `scripts/agent.sh "check nvidia-smi and kill any process using the GPU. respond with a summary."`
- scripts can call `~/scripts/infer.sh` for plain LLM inference (no tools). `infer` is an interactive zsh alias, so it doesn't work in scripts. modes: `infer.sh "prompt"`, `echo prompt | infer.sh`, `echo input | infer.sh "system prompt"`. stdout = response only; exit 1 on failure
  - `git commit -m "$(git diff | ~/scripts/infer.sh "respond with just a commit message")"`

### Layout
```
up.sh down.sh status.sh   user-facing lifecycle, dispatch on provider
config/active.env         which model is selected
config/models/*.env       per-model: provider, hardware, serving stack
scripts/providers/*.sh    provider backends, implement the lifecycle contract
docs/                     setup, architecture, models/, providers/
```
Lifecycle contract for a provider backend: `up`, `down`, `status`, `endpoint`. See `docs/architecture.md`.
