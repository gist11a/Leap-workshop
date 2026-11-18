# Module 7 · Real profit (about 30 minutes)

**They get:** what they really keep from each sale after Shopee's fees and their costs, the ad ROAS each product
needs to make money, and "profit yesterday" every morning.
**Files touched:** `rules/costs.json`, `rules/ads.json` (`target_roas`), `data/profit/`, `automations.json`.
The recipe `automations/profit-check.md` and the fee table `tools/shopee-fees.json` are already in their folder.
**Gate at the end:** `module8`.

Follow START.md's rules: short messages, lettered menus, one question at a time, no tech words.
**Never present an estimate as exact.** Say "about" for estimates, and say where each number came from.

---

## Step 1 · Open the module (one message)

Card:
```
MODULE 7 OF 11 · REAL PROFIT
──────────────────────────────────
YOU GET: what you really keep from every sale
```

Say, short:
- "Sales on Shopee look great. But from every RM100 sale, Shopee keeps a part, your product costs a part, and ads
  cost a part. What's left is yours."
- "Many sellers have never seen that last number. In 20 minutes you will, for each of your best sellers."
- "Reply YES when you're ready."

## Step 2 · Two facts about your shop (menus → `rules/costs.json` → `settings`)

Skip any that `rules/shop.json` or `rules/my-shop-info.md` already answer.
1. "Is your shop a Shopee Mall shop?" A) Yes B) No ★ C) Not sure. Save `is_mall` (Not sure → false; the real
   orders in Step 3 will show the true fees anyway).
2. "Are you on Shopee's **Cashback programme**? (In Singapore it's called **Promo Xtra**.) It's the one where
   Shopee adds cashback vouchers for your buyers and charges you a service fee."
   A) Yes ★ B) No C) Not sure. Save `on_programme` (Not sure → true; Step 3 will show it).

## Step 3 · Shopee's real fees, from your own orders

1. Say: "I'll check exactly what Shopee took from 3 of your recent orders. That's more accurate than any fee
   table. My helper only reads the money part, not the buyer's details."
2. Send ONE helper (Agent tool, `model: "sonnet"`, `subagent_type: "general-purpose"`, prompt = the text of
   `<HQ>/helpers/reader.md` + this job):
   > Open `<seller_centre>/portal/sale/order`, open the **Completed** tab. Open the 3 most recent orders whose
   > **Merchandise Subtotal** is more than 0 (click **Check Details** on each). On each order page, in **Payment
   > Information**, click **See Income Details** and collect: `merchandise_subtotal`, every fee line with its name
   > and amount (e.g. Commission Fee, Service Fee, Transaction Fee, Platform Support Fee), `shipping` lines,
   > `order_income`, and the order date. **Collect no buyer name, address or phone.**
   > Don't click anything else on the order page. Save to `<HQ>/data/fee-check.json` as
   > `{"read_at", "orders": [...]}`. Reply with the three fee totals only.
3. Work out, per order: **fee %** = (all percentage-type fees: commission + service + transaction) ÷
   merchandise_subtotal × 100; **fixed fee** = flat fees (e.g. platform support fee). Average the 3 orders.
   - Save `fee_percent_normal`, `fixed_fee_per_order`, `fees_from` "real orders", `fees_checked_on` today.
   - `fee_percent_campaign` = `fee_percent_normal` + the programme's campaign-day increase from
     `tools/shopee-fees.json` (Malaysia +2.16, Singapore +1.09), only if `on_programme`; else the same number.
     (If one of the 3 orders was on a campaign day, say so and keep it out of the normal average if the others differ.)
   - Seller-paid shipping on the orders (SG mostly): add the average to `fixed_fee_per_order`.
4. Say it plainly (EXAMPLE): "On your orders, Shopee takes about **21.5%** of the price, plus **RM0.54** per order.
   On big sale days (like 12.12) it's about **23.7%**, because the Cashback fee goes up."
5. **If the helper can't read the fees** (no completed orders, the page asks for a password, or the layout is
   different): use the fee table instead. "Which of these is closest to what you sell?" (menu of the categories in
   `tools/shopee-fees.json` for their market, last option "None of these"). Fee % = commission (Mall / programme
   column) + programme service fee (if on it) + transaction fee; fixed = platform fee + seller shipping. Save
   `fees_from` "fee table". "None of these" → "Shopee doesn't publish a rate I trust for that, so let's use your
   real orders after the workshop. For today I'll use 20% so we can carry on," and mark it clearly.
   Never type their password; if Shopee asks for it, they type it themselves or we use the fee table.

## Step 4 · Your product costs

1. Pick their **8 best sellers**: from `data/stock/<latest>.json` → `all_products` (highest `l7d`, the 7-day sales average;
   `l30d` if that's 0).
   If `rules/my-shop-info.md` has costs, use them and only ask about missing ones.
2. "What does one of each cost you, delivered to you? Rough is fine. Reply with the numbers in this order, or
   paste your cost list." List the products numbered, with their price if you know it (ask for the price too if not).
   ```
   1 Kopi O Drip Bag x10   (sells at RM29.90)   cost: ?
   2 Robusta Beans 500g    (RM38.00)            cost: ?
   …
   ```
3. "And packaging per order: box, tape, flyer?"
   ```
   A) Nothing much
   B) About RM0.50 ★
   C) About RM1
   D) Another amount — tell me
   ```
   Save `packaging_per_order`. Save products as `{"product", "price", "cost"}`.

## Step 5 · What you really keep (the reveal)

1. For each product: **fees** = price × fee% + fixed fee; **left before ads** = price − fees − cost − packaging;
   **margin** = left ÷ price × 100; **break-even ROAS** = price ÷ left (one decimal; none if left ≤ 0).
   Save `left_before_ads`, `margin_percent`, `break_even_roas` on each product.
2. Show it (EXAMPLE, worked out with fee 21.5% + RM0.54, packaging RM0.50):
   ```
   WHAT YOU KEEP PER SALE (before ads)
   ──────────────────────────────────
   Kopi O Drip Bag x10   RM29.90 → Shopee RM6.97 → cost RM9.50 → packing RM0.50 → you keep RM12.93 (43%)
   Robusta Beans 500g    RM38.00 → Shopee RM8.71 → cost RM17.00 → packing RM0.50 → you keep RM11.79 (31%)
   Hazelnut Blend 250g   RM24.90 → Shopee RM5.89 → cost RM13.80 → packing RM0.50 → you keep RM4.71 (19%)
   ```
3. Then the ads link, in plain words, one line per product:
   "**Break-even ROAS** is the ROAS where an ad makes no money and loses none. Below it, the ad loses money."
   ```
   Kopi O Drip Bag: ads must bring at least RM2.30 per RM1
   Robusta 500g: at least RM3.20 per RM1
   Hazelnut 250g: at least RM5.30 per RM1
   ```
   If Module 6 has ad data, connect it: "Your Robusta ad ran at 2.1 last week, below 3.2, so each sale from it lost
   money." That's usually the moment it lands. Don't make changes here; say "Your ads check now uses these
   numbers, so tomorrow's suggestions take this into account."
4. Update `rules/ads.json`: `target_roas` = total price ÷ total left-before-ads across these products, weighted by
   how much each sells (`l7d`), rounded **up** to the next 0.5. `target_roas_source` "profit". Say: "Your shop-wide ads target is
   now <n> (it was 4 as a starting point)."
5. Products with less than 10% margin: "This one barely makes money even without ads. Worth a price check, or no
   ads on it." Don't change prices.

## Step 6 · Profit yesterday, every morning

1. Add `{"id": "profit-check", "name": "Profit check", …}` to `automations.json` and follow
   `automations/profit-check.md` steps 2 to 5 now (live chat, so a helper for step 2).
2. Show the card (EXAMPLE):
   ```
   YESTERDAY · 18 NOV
   ──────────────────────────────────
   Sales RM1,284 · 41 orders
   Shopee fees −RM298 · product costs −RM706 · packing −RM21 · ads −RM38
   About RM221 profit (17%)
   ```
   If some products had no cost: "About 20% of this is estimated from your average margin. Add costs for more
   products any time: just tell me 'the Gift Box costs RM12'."
3. "Want this every morning?"
   ```
   A) Yes, every morning ★ (right after your ads check)
   B) Not now
   ```
   A → follow "How to schedule an automation" in `<HQ>/CLAUDE.md`: `taskId` `shopee-profit-check`, `title`
   "Shopee · Profit check", description "Works out yesterday's profit after Shopee fees, product costs and ads",
   time 35 minutes after `morning_check_at` (9:00 → `35 9 * * *`).
   Don't run it now: it gets its permission in Module 11, where one morning routine runs every check once
   together (and saves your allowance). Only if they must leave before Module 11: run it once now with
   `run_scheduled_task` and wait until it finishes before any helper uses the browser.

## Step 7 · Close the module

1. "Press **Cmd+R** / **Ctrl+R** on your dashboard: **Profit yesterday** is live at the top, and Real profit shows
   which products make or lose money."
2. Update `<HQ>/CLAUDE.md`: "Where we are: Module 7 done · next: module8". One line under "The shop", e.g.
   "Shopee fees about 21.5% + RM0.54 (from real orders, 19 Nov) · ads target ROAS 3 from profit."
3. Say:
   - "Done: you know what you really keep, product by product, and every morning you'll see yesterday's profit."
   - Value line: "Most sellers only find out at month end, from the bank. You'll know every morning."
   - "Quick check: Settings → Usage. If the bar is past about 70%, tell me."
   - Gate: "That's 7 of 11 done. Next, campaigns: Shopee's big sale days, and how to join them without
     selling at a loss. Type **module8** when you're ready."

## If things go wrong

- **They don't know their costs:** "A rough guess is fine, we can fix it later." Or do only the 3 products they do
  know; the rest are estimated from those.
- **Fee % comes out odd** (under 10% or over 35%): one order may have had a voucher, a return or shipping
  adjustments. Show the three orders' percentages, drop the odd one, or use the fee table and say why.
- **Sales on Business Insights don't match their own feeling:** Business Insights counts orders placed yesterday,
  including ones not yet shipped or paid out. "This is a daily estimate, not your bank statement."
- **A product makes a loss:** say it calmly and give one option ("raise the price a little, bundle it, or stop ads
  on it"). The decision is theirs. Never change a price.
- **SG shop:** Shopee SG charges the seller part of the shipping (about S$2.30 per order); real orders show it. Use S$.
