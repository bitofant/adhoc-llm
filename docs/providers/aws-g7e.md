# Provider: AWS g7e (big-VRAM)

For models too large for cheap providers. Currently: DeepSeek V4.1 Flash.

> **All figures below are from a planning session and are UNVERIFIED.** Confirm
> instance availability, specs and pricing in the target region before spending.

## Hardware
`g7e.24xlarge` — 4× RTX PRO 6000, 384 GB VRAM, 1 TB RAM, 7.6 TB local NVMe.
- spot: ~$4.75/hr — the intended mode
- on-demand: ~$16.57/hr — fallback when spot capacity is unavailable

## Storage (persists while off)
| what | where | ~cost/mo | why |
|---|---|---|---|
| weights (~510 GB) + kernel cache | S3, encrypted | ~$12 | cheap at rest, parallel pull to NVMe |
| NVIDIA driver + SGLang image | custom AMI | a few $ | cuts boot time |
| — | **not EBS** | — | avoids ~$120/mo throughput charges + slow lazy loading of restored volumes |

Idle total: ~$15–20/mo.

## Startup (~10–15 min warm)
1. launch spot instance from the AMI
2. parallel pull weights S3 → local NVMe
3. start container
4. smoke check; only then report the endpoint

## Safety rails — required before any unattended launch
- **idle watchdog**: terminate after `IDLE_SHUTDOWN_MIN` (30) with no requests
- **spot interruption**: 2-minute warning; client must fail over or relaunch gracefully
- **billing alarm**: AWS Budgets alert as backstop against a runaway instance
- **privacy**: API binds localhost, reached via Tailscale or SSH tunnel; SGLang request
  logging off; S3 bucket encrypted

## One-time setup (~1 hr) — not yet done
1. request GPU quota increase for G-family, **including spot** (often a separate quota)
2. download weights from HF, verify hashes, push to S3
3. run once to warm the kernel cache, save it to S3
4. bake the AMI
5. implement `scripts/providers/aws.sh` against the contract in `docs/architecture.md`

## Open questions
- does the spot quota request get approved, and at what limit
- g7e spot interruption rate in the chosen region — drives whether spot is usable at all
- pull time S3 → NVMe for 510 GB in practice vs the 10–15 min estimate
