# Provider: RunPod

The original target and still the cheap path: fast spin-up, per-second billing, no
quota dance. Intended for models that fit on 1–2 GPUs (GLM 5.3, Qwen3.8-flash-next,
Kimi K3 depending on variant).

## Status
Not implemented, not yet evaluated. Nothing here is verified.

## Why it stays despite the AWS plan
The AWS g7e path exists only because DeepSeek V4.1 Flash needs ~384 GB VRAM. Any
model that fits smaller hardware should run here instead — cheaper, faster to start,
and no AMI/S3 machinery.

## Privacy note — needs a decision before use
RunPod is a third party with access to the host. This is weaker than AWS only in
degree, not kind, but it should be assessed explicitly against the privacy driver
(secure cloud vs community cloud, disk encryption, what the host operator can see)
before any real prompts go through it.

## Open questions
- which models fit which RunPod SKUs at acceptable context length
- secure cloud vs community cloud, and the price delta
- spin-up time from a cached template, including weight download
- does per-second billing make the idle watchdog simpler than on AWS
