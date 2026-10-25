# Delectatio et Dominium — v0.1.0 release notes (DRAFT — user-reviewable pre-push)

Initial public version — the mod in active development. All features shipped through
this state are included; every module is pending its polish-and-expansion pass. This
is a stake in the ground, not a finished product: expect rough edges, expect change,
and expect version numbers to climb as milestones land.

**What's in this state:**

- **Baka Interactions** — paired NSFW interactions through the Interact power
  (affectionate, forced, and sexual actions), an escalation system with
  resistance / struggle / submit / call for help, capture, slavery, creature
  escalation, an execute-on-downed lane (EXPERIMENTAL), and a full MCM with a
  consolidated **Baka Interactions** page hosting six in-page sections.
- **GS Poses** — solo posing: a PrismaUI pose-grid selector and LLM-driven
  contextual NPC posing (the Muse), sharing one flat pose category with Baka
  Interactions.
- **Cum** — SkyrimNet triggers when cum is applied (OCum ModEvent path and a SexLab
  end-of-scene proxy), unified and per-source firing modes.
- **FILL HER UP (Baka Edition) inflation level cues**, keyed to its ModEvents.
- **SlaveTats** — LLM-driven tattoo-set application with NPC/player reactions.
- **Acheron Bridge** — downed-consequence triggers bridged to Acheron.

**Known labels:** the Execute action ships EXPERIMENTAL — guarded and labeled
in-game ("Execute action: experimental — community feedback welcome").

**Source transparency:** the repository ships full source, including the C++ source
of both plugin DLLs (`dll-source/` and `dll-source-gs/`, with the CommonLibSSE-NG
dependency as a pinned git submodule). If you build it yourself, use the pinned
submodule commit.

**Permissions & lineage:** original Baka/GS/Acheron sections by Around906 — used and
re-released with his permission (archived), under his community-spirited
full-takeover grant. Credited first and prominently in the README.
