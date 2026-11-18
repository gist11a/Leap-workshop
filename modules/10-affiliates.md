# Module 10 · Affiliates (about 20 minutes)

**They get:** yesterday's affiliate sales every morning, a check that no product pays affiliates more than it
earns, and simple rules for free-sample requests.
**Files touched:** `rules/affiliates.json`, `data/affiliates/`, `alerts.json`, `automations.json`.
The recipe `automations/affiliate-check.md` is already in their folder. Read it now.
**Gate at the end:** `module11`.

Follow START.md's rules: short messages, lettered menus, one question at a time, no tech words.
**Claude suggests; the owner changes commissions and approves samples in Shopee.** Keep this module short: it's
late in the day.

---

## Step 1 · Open the module (one message)

Card:
```
MODULE 10 OF 12 · AFFILIATES
──────────────────────────────────
YOU GET: affiliates that make you money, not cost you money
```

Say, short:
- "Affiliates are people (TikTokers, YouTubers, bloggers, deal pages) who share your product links. When someone
  buys through their link, they earn a commission."
- "You only pay when it sells. A 20% commission is like running ads at ROAS 5, but with no spend up front."
- "The catch: if a product's commission is bigger than its profit, every affiliate sale loses money. Let's check."
- "Reply YES when you're ready."

## Step 2 · Read your affiliate pages (one helper)

1. Add `{"id": "affiliate-check", "name": "Affiliate check", "when": "By hand for now", "status": "paused",
   "recipe": "automations/affiliate-check.md", "last_run": null, "last_result": null}` to `automations.json`.
2. Say: "Sending my helper to Affiliate Marketing: yesterday's sales, your commission rates, and sample requests.
   About 2 minutes."
3. Follow `automations/affiliate-check.md` steps 2 to 5, **including 2C** (the commission rates).
4. If the shop isn't in the affiliate programme: "You're not using Shopee affiliates yet. It's free to start:
   in Seller Centre → **Affiliate Marketing** → **Open Campaign**, add products and pick a commission. Your profit
   numbers from Module 8 tell you how high you can go." Show Step 3's table using their margins only (as "safe
   commission up to…"), skip Steps 4–5, and close.

## Step 3 · The commission check (the payoff)

1. Show it (EXAMPLE, using Module 8's margins):
   ```
   COMMISSION CHECK
   ──────────────────────────────────
   ✗ Hazelnut Blend 250g  pays 20% · makes 19% → loses about RM0.30 per affiliate sale
   ✓ Robusta Beans 500g   pays 15% · makes 31% → keeps 16%
   ↑ Kopi O Drip Bag x10  pays 10% · makes 43% → room to offer more
   ```
2. Explain in one line each:
   - "✗ means each affiliate sale of this product loses money. Lowering it to about <margin − 5>% fixes that."
   - "↑ means it's a best seller with lots of profit. Offering, say, 15–20% gets more affiliates to promote it."
3. "Want to change any commission now?"
   ```
   A) Yes, walk me through it ★
   B) Later
   ```
   A → they do it, you guide, one step per message: "In my browser: **Affiliate Marketing** → **Open Campaign**.
   Find **Hazelnut Blend 250g** in the list. Click its commission and set it to **14%**. Save." (Have the helper
   read the page again if they're unsure what's on screen.) Never change it yourself.
   Update `commission.by_product` afterwards ("I've noted Hazelnut is now 14%").

## Step 4 · Sample request rules (menus → `rules/affiliates.json`)

1. "Affiliates often ask for a free sample before they promote you. Who should get one?"
   ```
   A) Anyone who asks
   B) Only affiliates with 1,000+ followers ★
   C) Only 10,000+ followers
   D) I decide each one myself
   ```
   Save `approve_samples_when.min_followers` (0, 1000, 10000, null for D).
2. "How many free samples a week, at most?"
   ```
   A) 2
   B) 5 ★
   C) 10
   ```
   Save `max_samples_per_week`. `must_match_my_category` stays true (a food blogger for food products).
3. If `samples_to_approve` > 0: "You have <n> sample requests waiting. Click **To Approve** on the Affiliate
   homepage in my browser and reply DONE." Then a helper reads that page (`reader.md` + "read the open sample
   request list: affiliate name, followers, category, product requested; click nothing"). Show each one as
   ✓ fits your rules / ✗ doesn't (and why). The owner presses Approve or Reject themselves.

## Step 5 · Every morning

1. "Want the affiliate check every morning? It also re-checks your commissions every Monday."
   ```
   A) Yes ★
   B) Not now
   ```
2. A → follow "How to schedule an automation" in `<HQ>/CLAUDE.md`: `taskId` `shopee-affiliate-check`, `title`
   "Shopee · Affiliate check", description "Yesterday's affiliate sales, sample requests, and a Monday commission
   check", time **25 minutes** after `morning_check_at` (9:00 → `25 9 * * *`) so it runs before the profit check.
   Don't run it now: it gets its permission in Module 12, where one morning routine runs every check once
   together (and saves your allowance). Only if they must leave before Module 12: run it once now with
   `run_scheduled_task` and wait until it finishes before any helper uses the browser.
3. Say: "Your profit check now takes affiliate commission off too, so the profit number is complete."

## Optional extras (2 minutes, skip if short on time)

Ready-made extras from `<HQ>/automations/extras.md`. They ride along with the affiliate check, so there's nothing new to
schedule or approve, and most cost almost no allowance. Read only that file's "How it works" and this module's part.

1. "Want any extras? They run with your affiliate check. Pick any, e.g. **A C**, or none."
   ```
   A) Sort sample requests        when requests are waiting: which ones fit your rules
   B) Thank your best affiliates  Mondays: your top 3 affiliates, with ideas to keep them selling
   C) None for now ★
   D) Something else — tell me
   ```
2. Switch on each pick as "How it works" says (A = `sample-sorter`, B = `star-affiliates`). Ask only the setting a pick needs.
3. "Switched on. You can add or remove extras any time: just say **show my extras**."

## Step 6 · Close the module

1. "Press **Cmd+R** / **Ctrl+R** on your dashboard: the Affiliates card is live."
2. Update `<HQ>/CLAUDE.md`: "Where we are: Module 10 done · next: module11". One line under "The shop", e.g.
   "Affiliates: samples for 1,000+ followers, max 5 a week · Hazelnut commission lowered to 14%."
3. Say:
   - "Done: your affiliates are working for you, and no product pays out more than it earns."
   - Value line: "Affiliates are the cheapest marketing on Shopee, as long as the commission is right."
   - "Quick check: Settings → Usage. If the bar is past about 70%, tell me."
   - Gate: "That's 10 of 12 done. Next, your product images: what to fix so more people click.
     Type **module11** when you're ready."

## If things go wrong

- **No margins yet** (Module 8 skipped): show commissions only, and say "Tell me the cost of your top 3 products
  and I'll check them." Don't guess margins.
- **Est. Commission shows 0 with sales:** Shopee confirms commission later. Say "Shopee confirms commission a few
  days later; today's number may change."
- **Many products (hundreds) in Open Campaign:** check the top 30 sellers only. "I checked your best sellers; the
  rest are less urgent."
- **They want Claude to approve samples or change commissions:** "That one's yours. Samples cost you stock, and
  commission is a promise to affiliates. I'll always tell you which ones fit your rules."
