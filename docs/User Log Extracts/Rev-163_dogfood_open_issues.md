1\. There is still a stale direct narration event for FHU direct narration that reads as instructive. This could have been missed, or a reapplied old form.



16756

From: Frabbi

10/25/26 11:25



direct narration

Frabbi's belly is noticeably fuller now, swelling with warmth. How it shows on them, and how they or someone nearby takes it, is theirs -- embarrassment, pride, discomfort, desire, or casual acceptance -- true to who they are. Never explain what caused the swelling, and never name any framework or source -- describe only the state as it is visible right now.

It should read more like this:

"<Character> has swollen with cum. They react to how it looks, feels, and where it entered from."

2. The GS pose action calls still seem to be failing. Based on the action payload search, it doesn't even see the actions. Investigate the logs and check "D:\\Modding\\Skyrim\\Workspace\\Delectatio-et-Dominium\\docs\\User Log Extracts\\Rev-163\_failed\_dace\_action\_call.txt" for context.

3. The "force tattoo" button on the Baka prisma panel does not work for the player. My testing showed it did not work as a callable action for NPCs either. Remove it from the Prisma panel. The idea is that NPCs (through the LLM) can call a the action emergently when verbally commanded by the player, or under their own steam. The target needs to be downed.

4. I filled Frabbi with a combined cum amount of \~5.8 in FHU. Nearby character seemed to notice, but I didn't see the ambient narration fire.

5. The Acheron downed event has problems. It extenuates execution too much by placing it first, and giving it much more description that the other options. It also fires too many times. It should fire a maximum of twice, spaced about a minute apart. If nothing happens within that time, it should stop.

16830

From: Hadrian

To: Frabbi

10/25/26 11:52



direct narration

Frabbi is down. The moment wants an end, and the acts are close at hand: an executioner's finishing blow (Execute -- the deliberate killing blow on a downed victim, the one a victor chooses when the loser is an enemy wanted dead), pinning them where they lie (PinHelpless), a chokehold (ChokeHelpless), a helping hand up (HelpUp), or walking away and letting them crawl off (Release). Words can fill the space first -- questions, threats, mockery, demands for surrender or belongings -- but the moment ends in one of these.

Silver-Blood Inn, Hold: Markarth


6. I think all ambient cues need a sweep for instructive text. Since they are direct narration, they need to read more like the narration of a story, exactly like the trigger content changes.

