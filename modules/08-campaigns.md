# Module 8 · Campaigns (about 35 minutes)

**They get:** a price floor for every best seller (the lowest campaign price that still makes money), a list of
the campaigns that fit them with deadlines, and a price check before they nominate or confirm anything.
**Files touched:** `rules/campaigns.json`, `data/campaigns/`, `alerts.json`, `automations.json`.
The recipe `automations/campaign-check.md` is already in their folder. Read it now.
**Gate at the end:** `module9`.

Follow START.md's rules: short messages, lettered menus, one question at a time, no tech words.
**The owner presses Nominate and Confirm, never Claude.** Joining a campaign is a promise to Shopee about price
and stock. Claude prepares the list and checks the prices; the owner clicks.

---

## Step 1 · Open the module (one message)

Card:
```
MODULE 8 OF 11 · CAMPAIGNS
──────────────────────────────────
YOU GET: join the right sales, at prices that still make money
```

Say, short:
- "Shopee's sale days (11.11, 12.12, payday, mid-month) bring lots of buyers. To join, Shopee asks you for a
  discount."
- "Two things catch sellers out: Shopee's fees go **up** on those days, and the price Shopee suggests can be below
  what you can afford."
- "So first we work out your **price floor**: the lowest price where each product still makes money on a sale day.
  Then I check every campaign price against it."
- "Reply YES when you're ready."

## Step 2 · Your campaign rules (menus → `rules/campaigns.json`)

1. "Which kinds of campaigns do you want to hear about? Pick all that apply, e.g. **A B**."
   ```
   A) Big Campaigns (11.11, 12.12, payday, mid-month) ★
   B) Voucher Campaigns ★
   C) Shopee Flash Sales
   D) Live Stream campaigns
   ```
   Save `join_types` ("Big Campaign", "Voucher Campaign", "Shopee Flash Sale", "Live Stream").
   First answer: add "(Or just say YES and I'll use sensible defaults.)" YES → A B and the ★ defaults below.
2. "On a sale day, what's the least you want to keep from each sale, after Shopee's fees and your cost?"
   ```
   A) 5% (I'll go low to win traffic)
   B) 10% ★
   C) 15%
   D) Another number — tell me
   ```
   Save `price_floor.min_margin_percent`.
3. If `rules/my-shop-info.md` has a lowest-price list, use it: save to `owner_lowest_prices` and say "I'll never go
   below the prices you gave me." Otherwise ask: "Do you have your own list of lowest prices?" A) No, work it out ★
   B) Yes — paste it.
4. "Any products you never put on sale? Any campaigns you never join?" (free text or "no") → `exclude_products`,
   `never_join`.

## Step 3 · Your price floors (the key moment)

1. For each product in `rules/costs.json` → `products` (their best sellers from Module 7), with the
   **campaign-day** fee (`fee_percent_campaign`):
   **floor** = (`fixed_fee_per_order` + cost + `packaging_per_order` + `other_cost_per_order`) ÷
   (1 − campaign fee% − min margin%), rounded **up** to the next 10 sen.
   **Max discount** = 1 − floor ÷ normal price.
   Save to `price_floor.lowest_prices` (product → floor). If `owner_lowest_prices` has a higher number for a
   product, theirs wins; say so.
2. Show it (EXAMPLE: campaign fee 23.66% + RM0.54, packing RM0.50, keep at least 10%):
   ```
   YOUR PRICE FLOORS ON SALE DAYS
   ──────────────────────────────────
   Kopi O Drip Bag x10    normal RM29.90 → never below RM15.90 (up to 47% off)
   Robusta Beans 500g     normal RM38.00 → never below RM27.20 (up to 28% off)
   Hazelnut Blend 250g    normal RM24.90 → never below RM22.40 (up to 10% off)
   ```
3. Say: "So the drip bags can take a big discount. The hazelnut blend can't: more than 10% off and you lose
   money on each sale. That's worth knowing before 12.12."
   No costs from Module 7? "We need your product costs for this. Let's add three now," and ask for the 3 best
   sellers' costs (as in Module 7 Step 4).

## Step 4 · What's open for you right now

1. Add `{"id": "campaign-check", "name": "Campaign check", "when": "By hand for now", "status": "paused",
   "recipe": "automations/campaign-check.md", "last_run": null, "last_result": null}` to `automations.json`.
2. Say: "Sending my helper to your Campaign page. It only reads the list, it won't open or join anything."
3. Follow `automations/campaign-check.md` steps 2 to 5 (live chat, so a helper for step 2).
4. Show the result (EXAMPLE), at most 6 lines, most urgent first:
   ```
   CAMPAIGNS FOR YOU
   ──────────────────────────────────
   ⚠ December Campaign Pacing: Shopee proposed prices, waiting for your confirm (closes about 23 Nov)
   ⏱ 20 Nov BTO Sale (voucher): closes tomorrow 14:20
   ⏱ 21–23 Nov Super Tech Show (voucher): closes 20 Nov
   • Black Friday Cyber Monday: closes about 23 Nov
   ```
5. "Which one should we check prices for?" (menu of the top 3–4, plus "None today").

## Step 5 · Check the prices together, then you press the button

Follow "Checking prices for one campaign" at the bottom of `automations/campaign-check.md`:
1. "In my browser, click **Nominate Now** (or **Go To Confirm**) on **<campaign>**. Don't fill anything in yet.
   Reply DONE when the campaign page is open." (Show the browser first if needed: Cmd+Shift+B / Ctrl+Shift+B.)
2. Send the helper to read that page. Then show (EXAMPLE):
   ```
   PRICE CHECK · DECEMBER CAMPAIGN PACING
   ──────────────────────────────────
   ✓ Kopi O Drip Bag x10  Shopee asks RM19.90 · your floor RM15.90 · you keep 23%
   ✗ Robusta Beans 500g   Shopee asks RM26.60 · your floor RM27.20 · you'd keep 9%
   ✗ Hazelnut 250g        Shopee asks RM19.90 · your floor RM22.40 · you'd keep 2%
   Requirements: at least 10% off · campaign stock at least 20
   ```
3. Say: "My advice: join with the drip bags. Skip the other two, or offer them at your floor price if Shopee
   allows it."
4. **They do it, you guide.** One instruction per message, in Shopee's own words, e.g.:
   "Tick **Kopi O Drip Bag x10** only." → "Type **19.90** as the campaign price." → "Stock: how many can you set
   aside? Your stock check says you have <stock>; keep enough for normal orders." → "Now press **Submit** /
   **Confirm**. That's your decision to make."
   If unsure what's on screen, have the helper read the page again (text only) and guide from that.
   Never press Submit, Confirm or Nominate yourself, even if they ask: "That one's yours to press, so you're
   always in control of your prices."
5. After they submit: "Done! I'll see it under **Nominated** in tomorrow's check." Note in the day file's `note`.

## Step 6 · Deadline alerts every morning

1. "Want me to check campaigns every morning and warn you before deadlines and price offers?"
   ```
   A) Yes, every morning ★
   B) Not now
   ```
2. A → follow "How to schedule an automation" in `<HQ>/CLAUDE.md`: `taskId` `shopee-campaign-check`, `title`
   "Shopee · Campaign check", description "Lists campaigns that fit, deadlines and price offers waiting for the
   owner", time 45 minutes after `morning_check_at` (9:00 → `45 9 * * *`).
   Don't run it now: it gets its permission in Module 11, where one morning routine runs every check once
   together (and saves your allowance). Only if they must leave before Module 11: run it once now with
   `run_scheduled_task` and wait until it finishes before any helper uses the browser.

## Step 7 · Close the module

1. "Press **Cmd+R** / **Ctrl+R** on your dashboard: the Campaigns card shows what's open and what's closing."
2. Update `<HQ>/CLAUDE.md`: "Where we are: Module 8 done · next: module9". One line under "The shop", e.g.
   "Campaigns: Big + Voucher · keep at least 10% on sale days · price floors in rules/campaigns.json."
3. Say:
   - "Done: you know your price floor for every best seller, and you'll hear about deadlines before they pass."
   - Value line: "One campaign joined at the wrong price can wipe out a month's profit on that product. Now
     every price gets checked first."
   - "Quick check: Settings → Usage. If the bar is past about 70%, tell me."
   - Gate: "That's 8 of 11 done. Next, affiliates: people who sell your products for a commission.
     Type **module9** when you're ready."

## If things go wrong

- **Clicking Nominate Now opens nothing in Claude's browser:** the page may have opened in another window, or
  the campaign closed. Ask them to try once more; if still nothing, do the price check from the floors table alone
  ("Here are your floors; use them as your guide on the page").
- **Shopee doesn't show a suggested price:** compare their current price minus the required discount with the floor.
- **Voucher campaigns:** the discount comes from a voucher the shop funds, not a lower listed price. The maths is the
  same: price after the voucher must stay at or above the floor.
- **"less than 5 days" deadlines:** Shopee doesn't show the exact time. Say "about" and advise not to wait for the
  last day.
- **No costs for a product:** mark it "?" and say "Tell me its cost and I'll check it." Never guess a floor.
- **They want Claude to nominate for them:** "Not today. It's a price promise to Shopee, so you press the button.
  I'll always check the numbers first."
