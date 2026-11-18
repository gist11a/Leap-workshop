# Module 7 · Ads check (about 35 minutes)

**They get:** a plain-words picture of where their ad money goes, which ads waste it, a warning before ad credit
runs out, and a daily check that suggests changes for their YES.
**Files touched:** `rules/ads.json`, `data/ads/`, `approvals.json`, `alerts.json`, `automations.json`.
The recipe `automations/ads-check.md` is already in their folder. Read it now; you follow it in Step 3.
**Gate at the end:** `module8`.

Follow START.md's rules: short messages, lettered menus, one question at a time, no tech words.
**Shopee know-how for this module:** `<HQ>/knowledge/shopee-basics.md` §5 (read only that). Worth saying when it fits: GMV Max ads need at least 7 days to learn, so judge on 7 days, not yesterday; Shopee asks for changes of 10% or less, at most 1–2 a day; ROAS = sales ÷ expense.
**Money is involved here. Claude never tops up, never starts a new ad, never joins anything.** It reads, explains,
and suggests; the owner decides.

---

## Step 1 · Open the module (one message)

Card:
```
MODULE 7 OF 12 · ADS CHECK
──────────────────────────────────
YOU GET: where your ad money goes, and where it's wasted
```

Say, short:
- "Shopee Ads can grow sales fast, and it can also quietly spend money on ads that never sell."
- "Shopee shows lots of numbers. I'll turn them into three things: what you spent, what came back, and what to fix."
- "One word first: **ROAS**. It means sales ÷ ad spend. ROAS 5 means every RM1 of ads brought RM5 of sales."
- "Reply YES when you're ready."

## Step 2 · Your ads rules (two menus → `rules/ads.json`)

1. "Do you know the lowest ROAS where your ads still make money?"
   ```
   A) Yes — tell me the number
   B) No, use a safe starting point for today ★
   C) I don't run Shopee Ads
   ```
   - A → save `target_roas`, `target_roas_source` "owner".
   - B → save `target_roas` 4, `target_roas_source` "starting point". Say: "We'll use 4 for now: RM4 of sales for
     every RM1 of ads. In the next module we work out your real number from your profit."
   - C → "No problem. I'll still check your ad credit and tell you if anything starts spending." Save
     `target_roas` null. Do Step 3 anyway (it's quick); if no ads are running, skip to Step 6 and offer no schedule.
   First answer: add "(Or just say YES and I'll use sensible defaults.)" YES → B and the defaults below.
2. "When should I call an ad **wasted**? When it spends more than…, with no orders in a week."
   ```
   A) RM10
   B) RM20 ★
   C) RM50
   D) Another amount — tell me
   ```
   Save `wasted_spend.spend_over`.
3. Say (don't ask): "Two safety rules are already set: the only change I'll suggest is pausing an ad that sold
   nothing, and every change waits for your YES. Budgets stay your call."
4. "Any ads I should never touch? For example, a brand ad your agency manages." (free text or "no").
   Save to `never_touch`.

## Step 3 · Read your ads

1. Say: "Sending my helper to Shopee Ads. It looks at yesterday and the last 7 days. About 2 minutes."
   "Shopee Ads is full of 'Join now' and 'Top up' buttons. My helper is told never to press any of them."
2. Add to `automations.json` (if missing): `{"id": "ads-check", "name": "Ads check", "when": "By hand for now",
   "status": "paused", "recipe": "automations/ads-check.md", "last_run": null, "last_result": null}`.
3. Follow `automations/ads-check.md` steps 2 to 6 (live chat, so a helper for step 2).
4. While it reads: "While we wait: Shopee charges per click. A click that doesn't turn into an order still costs."

## Step 4 · Explain it in plain words

1. One card (EXAMPLE numbers):
   ```
   YOUR ADS · LAST 7 DAYS
   ──────────────────────────────────
   Spent RM212 → sales RM933 → ROAS 4.4 (your target: 4) ✓
   Yesterday: RM38 spent, ROAS 4.9
   Wasted: RM51 on 2 ads with no orders this week
   Ad credit: RM51 left, about 2 days at this speed ⚠
   ```
2. Then the ads list, at most 6 lines, worst first:
   ```
   ⚠ Hazelnut Search: RM24, 0 orders
   ⚠ Gift Box Ad: RM27, 0 orders
   ↓ Robusta 1kg: ROAS 2.1 (below your 4)
   ★ Kopi O Drip Bag: ROAS 9.8, 12 orders
   ```
3. Explain one line each, as plain as possible:
   - "The ⚠ ones cost money and sold nothing this week. Pausing them saves that money."
   - "The ↓ one sells, but each sale costs too much in ads."
   - "The ★ one is your winner. If it keeps running out of budget, giving it a bit more usually pays. That's
     your call, in Shopee Ads."
   - If credit is low: "When your ad credit hits zero, all your ads stop. Topping up is your call, in Shopee Ads.
     I'll never top up for you."
4. "Anything surprise you?"
   ```
   A) No, that's what I expected
   B) Yes, an ad shouldn't be there
   C) The numbers look wrong — tell me which
   D) Something else — tell me
   ```
   C → check the day file for that row; if the helper mismatched it, re-read only that ad (`find` its name).

## Step 5 · One change, with your YES (optional, the owner decides)

If step 3 made suggestions:
1. Show them numbered, one line each, plus what it means:
   ```
   7  Pause "Hazelnut Search" (RM24 in 7 days, no orders) — saves about RM3 a day
   8  Pause "Gift Box Ad" (RM27 in 7 days, no orders)
   ```
   "Reply **YES 7**, **YES all**, or **NO** to keep them running. You can switch them back on any time."
2. On YES: follow "What needs my YES?" in `<HQ>/CLAUDE.md` (one doer helper for all approved ad changes).
   Report: "Paused 1 ad ✓. You can see it in Shopee Ads → Ad Group & Individual Ads."
3. If the doer reports the screen looked different and stopped: "Shopee's ad screen looked different, so my helper
   stopped instead of guessing. Let's do this one together:" and walk them through pausing it themselves.
4. No suggestions? "Nothing to change today. Your ads are behaving."

## Step 6 · Make it run every morning

1. "Want me to check your ads every morning and suggest changes for your YES?"
   ```
   A) Yes, every morning ★ (15 minutes after your stock check)
   B) Only on weekdays
   C) Not now
   ```
2. A or B → follow "How to schedule an automation" in `<HQ>/CLAUDE.md` for `ads-check`: `taskId`
   `shopee-ads-check`, `title` "Shopee · Ads check", description "Reads Shopee Ads, flags wasted spend and low
   credit, suggests changes for the owner's YES". Time: 15 minutes after `morning_check_at` (9:00 → `15 9 * * *`)
   so the two checks don't share the browser. Update `ads-check` in `automations.json` to `on` with `when` in plain words.
3. Don't run it now: it gets its permission in Module 12, where one morning routine runs every check once
   together (and saves your allowance). Only if they must leave before Module 12: run it once now with
   `run_scheduled_task` and wait until it finishes before any helper uses the browser.

## Optional extras (2 minutes, skip if short on time)

Ready-made extras from `<HQ>/automations/extras.md`. They ride along with the ads check, so there's nothing new to
schedule or approve, and most cost almost no allowance. Read only that file's "How it works" and this module's part.

1. "Want any extras? They run with your ads check. Pick any, e.g. **A C**, or none."
   ```
   A) Don't advertise what you can't ship  every day: ads still running on out-of-stock products
   B) Ads that deserve more                Mondays: your best ads, if you want to grow them
   C) Spend spike alarm                    every day: ad spend jumped but sales didn't
   D) None for now ★
   E) Something else — tell me
   ```
2. Switch on each pick as "How it works" says (A = `ads-stock-guard`, B = `ads-winners`, C = `spend-spike`). Ask only the setting a pick needs.
3. "Switched on. You can add or remove extras any time: just say **show my extras**."

## Step 7 · Close the module

1. "Press **Cmd+R** / **Ctrl+R** on your dashboard: the Ads card and the ad boxes at the top are live."
2. Update `<HQ>/CLAUDE.md`: "Where we are: Module 7 done · next: module8". One line under "The shop", e.g.
   "Ads: target ROAS 4 (starting point, fix in Module 8) · wasted = RM20+ with no orders in a week."
3. Say:
   - "Done: you can see where your ad money goes, and I'll flag waste every morning."
   - Value line: "Most shops waste 10–20% of their ad money on ads that don't sell. Now you'll see it within a day."
   - "Quick check: Settings → Usage. If the bar is past about 70%, tell me."
   - Gate: "That's 7 of 12 done. Next, the big question: after Shopee's fees, ads and your costs, what do you
     really keep? Type **module8** when you're ready."

## If things go wrong

- **The helper got stuck on a pop-up** (a "Join now" banner covering the page): it should close it with the X or
  Escape, never "Join". If it can't, have the owner close it in the browser, then send the helper again.
- **Numbers don't match what the owner sees:** Shopee Ads shows "Today" by default. Check the helper switched to
  Yesterday / Past 1 week. If the owner compares with another screen (e.g. Business Insights), say "Ads only counts
  sales that came from an ad click, so it's lower than your total sales. That's normal."
- **Shop GMV Max only (no ad groups):** Shopee runs those ads itself. Report the numbers, flag waste per product,
  but suggest no changes: "Shopee manages these. If you want to change them, it's in Shopee Ads → Shop GMV Max."
- **Currency:** an SG shop shows `$`. Keep `S$` in what you say.
- **They ask Claude to top up or create an ad:** "That's spending money, so it stays with you. I'll tell you when
  credit is low and which ads earn the most."
