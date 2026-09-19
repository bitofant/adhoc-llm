# DeepSeek V4.1 Flash

Official weights, unquantized. Chosen so that no third party sees prompts.

> Figures from a planning session, **UNVERIFIED**. Confirm before relying on them.

Config: `config/models/deepseek-v41-flash.env` · Hardware: `docs/providers/aws-g7e.md`

## Serving stack
SGLang, via 0xSero's Docker recipe for 4× RTX PRO 6000:
- native (unquantized) weights
- DSpark speculative decoding
- TP4

Engram tables: start in **NVMe mode** (what the recipe tests) on the instance-local
NVMe. **RAM mode** is possible given 1 TB RAM but the recipe marks it unverified —
try it second, measure, record here.

## Expected performance (single user)
| metric | estimate |
|---|---|
| prefill | ~6k tok/s |
| decode | ~160 tok/s |
| max context | up to 400k |

Comfortably covers the 1–5 parallel request target.

## Cost vs API — explicit tradeoff
Self-hosting is **not** cheaper here. At Fireworks ZDR rates (~$0.22 in / $0.66 out
per M tok) you'd need heavy sustained use within an hour to beat ~$4.75/hr spot.
The justification is privacy; see CLAUDE.md Goal.

## Fallback
Baseten or Fireworks with zero data retention, when the 10–15 min startup isn't worth
it or spot capacity is unavailable. ZDR is a contractual guarantee, not a technical
one — a weaker privacy position than self-hosting, so treat it as a deliberate
downgrade, not a default.

## Status / next steps
Nothing run yet. Blocked on the one-time AWS setup in `docs/providers/aws-g7e.md`.
Verify first: exact HF repo id, weights size, that the 0xSero recipe still matches
the current release.
