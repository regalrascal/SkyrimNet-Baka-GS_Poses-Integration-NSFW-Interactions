; HAND-WRITTEN MINIMAL STUB (REV-82) — public-safe; no upstream code copied.
; Runtime source (stub-parity gated): OSL Aroused - Arousal Reborn
;   D:\Modlists\LoreRim\mods\[NoDelete] [034.00002] SLOStim Shared - OSL Aroused - Arousal Reborn\Scripts\Source\OSLArousedNative.psc
; (SLO Aroused NG ships the same scriptname as a Papyrus wrapper with the same
;  GetArousalNoSideEffects(Actor) signature — subset-compatible.)
; Used by: SNBaka_SlaveTatsModule._ArousalClause (REV-82 §7 tier clause).
; NOTE: GetArousal has time-update side effects (Reborn) — fire-time reads must use
; GetArousalNoSideEffects. Only members our sources call are declared.
Scriptname OSLArousedNative hidden

float function GetArousalNoSideEffects(Actor akActor) global
	return 0.0
endfunction
