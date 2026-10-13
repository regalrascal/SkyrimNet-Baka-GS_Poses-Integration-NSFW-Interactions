
---

**Working note (REV-104, 2026-10-12):** the fold-era content gap CLOSED this rev - the
external/around906.acheron-integration layer never had a manifest.json (the Task-2d
draft above was never landed), so the loader folder-rejected it silently from REV-62
onward; both triggers (acheron_downed, acheron_recovered) were dead framework-side
while the bridge script kept firing their RegisterEvent channel with deliberately
bare cues (psc L946-948). Manifest authored per the 62-era proposal, updated to current
state (sha256 00F80C57..; description + tagline registered pending-approvals entry 13,
dogfood-gated). Layer validates ok=true (2 expected EVENT_TYPE_UNKNOWN warnings - our
own script is the emitting mod). Full receipts: PROJECT_STATE 110 + era doc REV-104
section. Dogfood gates 5.1(a)-(d) pending user session.
