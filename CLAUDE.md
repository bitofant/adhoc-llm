# Ad-Hoc LLM
- always keep CLAUDE.md accurate and complete
- in .md files use terse language, assume the reader is a highly capable AI agent like yourself, be mindful of their context window

### Goal
- spin up an LLM on runpod.ai
- set up everything so it can be used locally
- add local proxy that forwards to the LLM on runpod when it's running, else to a local LLM
- we are looking for awesome cost performance when running the LLM for a short period of time (tens of minutes to a few hours)

### Details
- runtime should be optimized for 1-5 requests in parallel tops
- we can make do with reduced context windows if it puts us under a threshold so we can run on a significantly cheaper machine
- we don't really want a heavily quantized model variant
- whenever considering quantization, either model or kv cache, you need to show that performance does not meaningfully degree and you need user signoff 
- we'll try out a couple of models, e.g. GLM 5.3, Qwen3.8-flash-next, Kimi K3, and it's important to codify the setup and hardware to run on
- the need for custom commands should be absolutely minimized. create shell scripts for common actions, rely on config files e.g. for model selection, setup per model etc
- use `docs/` for documentation, e.g. a file `doce/kimi-k3.md` that documents decisions and findings around running Kimi K3
- put main scripts intended to be used by the user at the top level directory of this repo; use `scripts/` for scripts called by other scripts or for agent use
- local setup of a fresh clone: `docs/setup.md`
- scripts can call a coding agent via `scripts/agent.sh` (uses pi, falls back to claude, both without permission prompts). args + stdin passed through; stdout = final response. never call a harness (`pi`, `claude`, ...) directly
  - `scripts/agent.sh "check nvidia-smi and kill any process using the GPU. respond with a summary."`
- scripts can call `~/scripts/infer.sh` for plain LLM inference (no tools). `infer` is an interactive zsh alias, so it doesn't work in scripts. modes: `infer.sh "prompt"`, `echo prompt | infer.sh`, `echo input | infer.sh "system prompt"`. stdout = response only; exit 1 on failure
  - `git commit -m "$(git diff | ~/scripts/infer.sh "respond with just a commit message")"`
