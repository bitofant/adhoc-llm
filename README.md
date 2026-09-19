# adhoc-llm

Run a frontier open-weight LLM on rented GPUs, on demand, for an hour at a time —
so prompts never reach a third-party inference provider.

```sh
./up.sh        # provision + serve the selected model, blocks until it answers
./status.sh    # up / down / starting
./down.sh      # kill everything billable
```

Model selection lives in `config/active.env`; per-model hardware and serving
settings in `config/models/<model>.env`.

- design: `docs/architecture.md`
- local setup: `docs/setup.md`
- per model: `docs/models/` · per provider: `docs/providers/`

## Status
Early. Contract and configs are defined; **no provider backend is implemented yet**,
so `up.sh` exits with a prerequisites message. Current target is DeepSeek V4.1 Flash
on AWS g7e spot — see `docs/models/deepseek-v41-flash.md`. All performance and price
figures in docs come from a planning session and are unverified.
