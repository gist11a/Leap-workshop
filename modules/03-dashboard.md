# Module 3 · Your dashboard (about 25 minutes)

**They get:** one page with their whole shop on it, on their own laptop, arranged the way they like.
**Files touched:** `dashboard/layout.json` (their changes), `dashboard/data.js` (rebuilt by the refresh step).
**Gate at the end:** `module4`.

Follow START.md's rules: short messages, lettered menus, one question at a time, no tech words.
The dashboard page is ready-made. **Never edit `dashboard/index.html`.** Everything they change goes in
`dashboard/layout.json` (the rules for that are in `<HQ>/CLAUDE.md`, "When the owner wants the dashboard changed").

---

## Step 1 · Open the module (one message)

Card:
```
MODULE 3 OF 12 · YOUR DASHBOARD
──────────────────────────────────
YOU GET: your whole shop on one page
```

Say, short:
- "Every check I do gets saved in your Shopee HQ. The dashboard turns those notes into one page you can glance at."
- "It's a page on your laptop, not a website. Nobody else can see it, and it doesn't need a login."
- "Most of it is empty right now. It fills in as we go through the day."
- "Reply YES and I'll open it."

## Step 2 · Refresh and open it

1. Run the refresh step: `bash "<HQ>/tools/refresh-dashboard.sh" "<HQ>"` (quietly).
2. Open the page in their normal web browser:
   - Mac: `open "<HQ>/dashboard/index.html"`
   - Windows: `explorer.exe "<HQ in Windows form, e.g. C:\Users\Aisha\OneDrive\Desktop\Shopee HQ>\dashboard\index.html"`
     (explorer may report an error even when it worked; ignore that and ask them.)
3. Say: "Your dashboard just opened in your web browser (Chrome, Safari or Edge). Can you see it?"
   ```
   A) Yes, I can see it
   B) Nothing opened
   C) Something else — tell me
   ```
   - B → "Open your Shopee HQ folder on your Desktop, then the **dashboard** folder, then double-click
     **index**." If that fails too, wave a trainer over and keep going: the rest of the module still works.
4. "Bookmark it now so you can find it tomorrow: press **Cmd+D** (Mac) or **Ctrl+D** (Windows)."

## Step 3 · A short tour (one message, then pause)

Say it like a walk around the room, each line one part of the page, top to bottom:
- "**Top:** your shop name and when it was last updated. Updated means: the last time I checked."
- "**The six boxes:** your key numbers each morning, with a little line showing the last two weeks.
  Most say 'Not set up yet'. Each one wakes up in its module today."
- "**Needs you:** anything I want to change in your shop waits here for your YES, plus alerts like low stock."
- "**Automations:** the checks that run by themselves. Your first one arrives before lunch."
- "**One card per job** (stock, chats, ads, profit, campaigns…), then **My shop today** and **My rules**,
  which already has what you told me in Module 2."
- "The dark bar at the bottom jumps between cards."
- "To update it any time: ask me **refresh my dashboard**, then press **Cmd+R** / **Ctrl+R** on the page."
"Reply YES and we'll make it yours."

## Step 4 · Make it yours (the interactive part)

"What would you like to change? Pick one. We'll do two changes, then move on."
```
A) Choose the numbers in the six boxes at the top
B) Move a card higher, like Ads or Stock first
C) Hide cards you don't need, like Affiliates
D) Give it your own name, like "Kopi & Co HQ"
E) Add a sticky note, like a supplier reminder
F) Something else — tell me
```

For every change:
1. Change `dashboard/layout.json` only (keep it valid), then run the refresh step.
2. Say: "Done. Press **Cmd+R** (Mac) or **Ctrl+R** (Windows) on the dashboard." Then: "See it?"
3. After the first change: "One more? Pick another letter, or say NEXT." After the second, go to Step 5.

How to handle each pick:
- **A · The six boxes.** Show this menu, in plain words, and let them pick up to six letters (e.g. "A C F H"):
  ```
  A) Orders to process          (from your Seller Centre home page)
  B) Returns and cancels        (home page)
  C) Products low on stock      (Module 4)
  D) Products out of stock      (Module 4)
  E) Chats waiting for a reply  (Module 6)
  F) Bad reviews to reply to    (Module 6)
  G) Ad spend yesterday         (Module 7)
  H) Ad sales per RM1, yesterday (Module 7)
  I) Ad money spent with no orders, 7 days (Module 7)
  J) Profit yesterday           (Module 8)
  K) Campaign deadlines this week (Module 9)
  ```
  Topic and field for each: A home/`to_process` (neutral), B home/`return_refund_cancel` (bad), C stock/`low_stock`
  (bad), D stock/`out_of_stock` (bad), E chats/`waiting` (bad), F reviews/`bad_to_reply` (bad), G ads/`spend_yesterday`
  (neutral, money), H ads/`roas_yesterday` (good), I ads/`wasted_spend_7d` (bad, money), J profit/`profit` (good, money),
  K campaigns/`deadlines_this_week` (neutral). Keep their order. Tell them: "Boxes for later modules show
  'Not set up yet' until we get there."
  Fewer than three? "Three to six reads best. Want to add one more?"
- **B · Move a card.** "Which card should be higher?" (menu of the card names). Then: "Right under **Needs you**,
  or at the very top?" Move it in `sections`.
- **C · Hide cards.** Menu of card names, several letters allowed. Set `"show": false`. Never hide **Needs you**
  without warning: "That's where changes wait for your YES. Hide it anyway?"
  Say: "They're only hidden, not deleted. Ask me to bring them back any time."
- **D · Name.** Free text. Save as `title`. It shows at the top left and in the browser tab.
- **E · Sticky note.** "What should the note say?" (free text). Add `{"title": "<2–3 words>", "text": "<their words>"}`
  to `notes`. Notes show under the six boxes until they ask you to remove them.
- **F · Something else.**
  - Renaming a number ("call it 'Orders to pack'") → `labels` or the box `label`.
  - A new kind of chart, colours, a new layout → "That needs a change to the page itself. I've written it on your
    wishlist and we can do it after the workshop." Add a line under a `## Dashboard wishlist` heading in
    `<HQ>/CLAUDE.md`. Don't edit the page today.

## Step 5 · Close the module

1. Update `<HQ>/CLAUDE.md`: "Where we are: Module 3 done · next: module4". Under "How the owner likes things",
   one line on what they put first (e.g. "Wants Ads and Stock at the top").
2. Say:
   - "Done: you have a dashboard, and it's arranged your way."
   - "Remember: **refresh my dashboard**, then Cmd+R / Ctrl+R. After lunch your automations refresh it for you."
   - Value line: "Shops pay for dashboard tools every month. Yours is free, private, and shows exactly what you want."
   - "Quick check: Settings → Usage. If the bar is past about 70%, tell me."
   - Gate: "That's 3 of 12 done. Next, stock: I'll find what's about to run out and how much to reorder.
     Type **module4** when you're ready."

## If things go wrong

- **The page looks empty or old after a change:** they didn't reload. "Press Cmd+R / Ctrl+R on the dashboard page."
  Still old? Run the refresh step again and check it said "Dashboard refreshed".
- **The page shows 'No data yet':** the refresh step didn't run or couldn't write. Run it again; if it fails, check
  the folder location in `<HQ>/CLAUDE.md` matches the real folder.
- **"Needs you" says a file can't be read:** that file isn't valid. Open it, fix it (or delete a broken day file;
  the next check writes it again), refresh. Only that card is affected meanwhile.
- **A card says "Couldn't show this":** a data file for that card is broken. Look at the newest file in that topic's
  data folder, fix or delete it, refresh. Tell them: "One of my notes was messy. Fixed."
- **Fonts look plain:** the laptop is offline. Everything still works; the nicer fonts come back with internet.
- **They want to see it on their phone:** "It lives on this laptop, which keeps your data private. In the last
  module we can set up a morning summary in your Gmail drafts, which you can read on your phone."
