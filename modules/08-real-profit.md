# Module 8 · Real profit (about 30 minutes)

**They get:** what they really keep from each sale after Shopee's fees, shipping, packing and their own costs, the
ad ROAS (and ad cost per order) each product needs to make money, and "profit yesterday" every morning.
**Files touched:** `rules/costs.json`, `rules/ads.json` (`target_roas`), `data/profit/`, `automations.json`.
The recipe `automations/profit-check.md` and the fee table `tools/shopee-fees.json` are already in their folder.
**Gate at the end:** `module9`.

Follow START.md's rules: short messages, lettered menus, one question at a time, no tech words.
**Shopee know-how for this module:** `<HQ>/knowledge/shopee-basics.md` §6 (read only that). Worth saying when it fits: campaign days raise Shopee's programme fee on every order, nominated or not; Shopee-funded vouchers don't cost the shop, and a shop's own RM5 voucher costs about RM4; at low order numbers, running costs per order are often the biggest lever.
**Never present an estimate as exact.** Say "about" for estimates, and say where each number came from.

---

## Step 1 · Open the module (one message)

Card:
```
MODULE 8 OF 12 · REAL PROFIT
──────────────────────────────────
YOU GET: what you really keep from every sale
```

Say, short:
- "Sales on Shopee look great. But from every RM100 sale, Shopee keeps a part, delivery and packing take a part,
  your product costs a part, and ads cost a part. What's left is yours."
- "Many sellers have never seen that last number. In 20 minutes you will, for each of your best sellers."
- "Reply YES when you're ready."

## Step 2 · A few facts about your shop (menus → `rules/costs.json` → `settings`)

Skip any that `rules/shop.json` or `rules/my-shop-info.md` already answer. Ask one at a time.
1. "Is your shop a Shopee Mall shop?" A) Yes B) No ★ C) Not sure. Save `is_mall` (Not sure → false; the real
   orders in Step 3 will show the true fees anyway).
2. "Are you on Shopee's **Cashback programme**? (In Singapore it's called **Promo Xtra**.) It's the one where
   Shopee adds cashback vouchers for your buyers and charges you a service fee on **every** order."
   A) Yes ★ B) No C) Not sure. Save `on_programme` (Not sure → true; Step 3 will show it).
3. **Singapore only:** "Is your company **registered for GST**? Most shops aren't: it's only a must above S$1m a
   year." A) No ★ B) Yes C) Not sure. Save `gst_registered` (Not sure → false, and say "ask your accountant; it
   changes your profit by about 6% of every sale, so it's worth knowing").

## Step 3 · Shopee's real fees, from your own orders

1. Say: "I'll check exactly what Shopee took from 3 of your recent orders. That's more accurate than any fee
   table. My helper only reads the money part, not the buyer's details."
2. Send ONE helper (Agent tool, `model: "sonnet"`, `subagent_type: "general-purpose"`, prompt = the text of
   `<HQ>/helpers/reader.md` + this job):
   > Open `<seller_centre>/portal/sale/order`, open the **Completed** tab. Open the 3 most recent orders whose
   > **Merchandise Subtotal** is more than 0 (click **Check Details** on each). On each order page, in **Payment
   > Information**, click **See Income Details** and collect: `merchandise_subtotal`, every voucher or discount
   > line with its name and who paid it (seller or Shopee), every fee line with its name and amount (e.g.
   > Commission Fee, Service Fee, Transaction Fee, Ads Escrow Top-Up, AMS Commission Fee), every shipping line
   > (paid by buyer, charged by the courier, Shopee rebate), `order_income`, the order date and the payment method
   > if it's shown. **Collect no buyer name, address or phone.** Don't click anything else on the order page.
   > Save to `<HQ>/data/fee-check.json` as `{"read_at", "orders": [...]}`. Reply with the three fee totals only.
3. Work it out, per order (rates, tax and line names: `tools/shopee-fees.json` → `how_fees_work` and the market's
   `income_details_note`):
   - **Price after your voucher** = merchandise_subtotal − the shop's **own** vouchers and discounts. Vouchers
     Shopee paid for don't count: Shopee adds them back, so they cost the shop nothing.
   - **Malaysia:** the one "Service Fee" line is two fees together: take **RM0.54** off it (the platform support
     fee) and keep that as a flat fee.
   - **Fee %** = (commission + service fee + transaction fee) ÷ price after your voucher × 100. Leave out the
     affiliate (AMS) commission (the affiliate check counts it) and, in Malaysia, any **Ads Escrow Top-Up** line:
     that's their ads being paid from their sales, and the ads check already counts ad spend. If you see it, say so
     in one line: "That RM<x> isn't a Shopee fee, it's your ads paid from the sale; I count ads separately."
   - **Fixed fee** = Malaysia: RM0.54. Singapore: the seller's shipping (courier charge − what the buyer paid −
     Shopee's shipping rebate) + S$0.07 (the transaction fee on the buyer's S$1.99 shipping).
   - **Leave out of the average** an order that was: on a campaign day, paid by instalment (its transaction fee
     is higher: MY 4.86% instead of 3.78%), a pre-order (MY adds 2.16%), or partly refunded. Say which and why.
     If all 3 are like that, open the next ones.
   Average the orders that are left, then save:
   - `fee_percent_normal`, `fixed_fee_per_order`, `fees_from` "real orders", `fees_checked_on` today.
   - `fee_percent_campaign` = `fee_percent_normal` + the programme's campaign-day increase (Malaysia +2.16,
     Singapore +1.09), only if `on_programme`; else the same number.
   - `service_fee_cap_per_item` from the fee table (MY RM108; SG S$60, S$70 on campaign days). It only matters on
     very expensive items (over about RM1,800 or S$1,100).
   - **GST-registered SG shop:** fee % = Shopee's fee % ÷ 1.09 + 8.26 (the GST in the fees comes back, but the shop
     pays 9/109 of what buyers paid). Say so in one line.
4. Say it plainly (EXAMPLE): "On your orders, Shopee takes about **24.3%** of the price after your voucher, plus
   **RM0.54** per order. On big sale days (like 12.12) it's about **26.5%**, because the Cashback fee goes up."
   Then the voucher fact: "Good to know: a RM5 shop voucher costs you about RM4, because Shopee's fees shrink
   with the price. Vouchers Shopee pays for cost you nothing."
5. **If the helper can't read the fees** (no completed orders, the page asks for a password, or the layout is
   different): use the fee table instead. "Which of these is closest to what you sell?" (menu of the categories in
   `tools/shopee-fees.json` for their market, using their `covers` words, last option "None of these").
   - Fee % = commission (Mall / programme column) + programme service fee (if on it; Singapore: the category's
     `service_band`) + transaction fee. GST-registered SG: as above.
   - Fixed = Malaysia: RM0.54. Singapore: seller shipping by parcel weight + S$0.07. Ask: "How heavy is a typical
     parcel, box included?" A) Under 1 kg ★ (S$2.30) B) 1–5 kg (S$3.21) C) 5–10 kg (S$3.79) D) Heavier: tell me.
     A big light box counts by size (L × W × H in cm ÷ 6000). Save `parcel_size`. Fulfilled by Shopee shops use
     the cheaper `fulfilled_by_shopee` card.
   - Save `fees_from` "fee table". "None of these" → "Shopee doesn't publish a rate I trust for that, so let's use
     your real orders after the workshop. For today I'll use 25% so we can carry on," and mark it clearly.
   Never type their password; if Shopee asks for it, they type it themselves or we use the fee table.

## Step 4 · Your costs

1. Pick their **8 best sellers**: the highest `units_30d` in the newest `data/sales-speed/` file (real units sold;
   Shopee's rounded inventory averages aren't good enough for this).
   If `rules/my-shop-info.md` has costs, use them and only ask about missing ones.
2. "What does one of each cost you, **including getting it to you**? (The supplier's price plus the shipping or
   freight to your shop or warehouse.) Rough is fine. Reply with the numbers in this order, or paste your cost
   list." List the products numbered, with their price if you know it (ask for the price too if not).
   ```
   1 Kopi O Drip Bag x10   (sells at RM29.90)   cost: ?
   2 Robusta Beans 500g    (RM38.00)            cost: ?
   …
   ```
   Malaysia: if any is sold as **pre-order**, mark it `preorder: true` (Shopee adds 2.16% on those).
3. "Who packs your orders?" Save `packing`.
   ```
   A) We pack them ourselves ★
   B) A warehouse company (3PL) packs and sends them
   C) Fulfilled by Shopee (FBS)
   ```
   - A → "And packaging per order: box, tape, flyer?" A) Nothing much B) About RM0.50 ★ C) About RM1 D) Another
     amount. Save `packaging_per_order`; `other_cost_per_order` 0.
   - B → "What does the warehouse charge per order, and per extra item in the same order? Check an invoice if you
     can." `other_cost_per_order` = per order + extra items for a typical order + the warehouse's packaging if
     separate, **plus tax**: Malaysia +8% SST; Singapore +9% GST unless GST-registered. `packaging_per_order` 0.
   - C → the per-item fee for their usual size from `fulfilled_by_shopee` (packing is included), plus the same tax.
     Singapore: FBS also makes the seller's shipping cheaper; use that card in the fixed fee.
4. **Running costs** (optional, but often the biggest surprise): "Roughly what does the business spend each month
   that isn't per order? Staff, rent, software, warehouse minimums."
   ```
   A) Skip for now ★
   B) About RM1,000
   C) About RM3,000
   D) Another amount — tell me
   ```
   Save `monthly_fixed_costs`. `orders_per_month` = `orders_30d` from the newest `data/scan/` file (else ask).
   `overhead_per_order` = monthly ÷ orders, 2 decimals. Say: "That's about RM<x> on every order. The more orders
   you get, the smaller it gets."
5. Save products as `{"product", "price", "cost"}` (plus `preorder` if true).

## Step 5 · What you really keep (the reveal)

1. For each product: **fees** = price × fee% (+ 2.16% if `preorder`) + fixed fee; **left before ads** = price −
   fees − cost − `packaging_per_order` − `other_cost_per_order` − `overhead_per_order`;
   **margin** = left ÷ price × 100; **break-even ROAS** = price ÷ left (one decimal; none if left ≤ 0);
   **break-even ad cost** = left (the most ads may cost per order before the sale loses money).
   Save `left_before_ads`, `margin_percent`, `break_even_roas`, `break_even_ad_cost` on each product.
2. Show it (EXAMPLE, worked out with fee 24.3% + RM0.54, packaging RM0.50, running costs RM2.50 an order):
   ```
   WHAT YOU KEEP PER SALE (before ads)
   ──────────────────────────────────
   Kopi O Drip Bag x10   RM29.90 → Shopee RM7.81 → cost RM9.50 → packing RM0.50 → running RM2.50 → you keep RM9.59 (32%)
   Robusta Beans 500g    RM38.00 → Shopee RM9.77 → cost RM17.00 → packing RM0.50 → running RM2.50 → you keep RM8.23 (22%)
   Hazelnut Blend 250g   RM24.90 → Shopee RM6.59 → cost RM13.80 → packing RM0.50 → running RM2.50 → you keep RM1.51 (6%)
   ```
   Leave out the "running" step if they skipped it, and say the numbers are before running costs.
3. Then the ads link, in plain words, one line per product:
   "**Break-even ROAS** is the ROAS where an ad makes no money and loses none. Below it, the ad loses money."
   ```
   Kopi O Drip Bag: ads must bring at least RM3.10 per RM1 · at most RM9.59 of ads per order
   Robusta 500g:    at least RM4.60 per RM1 · at most RM8.23 per order
   Hazelnut 250g:   at least RM16.50 per RM1 · at most RM1.51 per order
   ```
   If Module 7 has ad data, connect it: "Your Robusta ad ran at 2.1 last week, below 4.6, so each sale from it lost
   money." That's usually the moment it lands. Don't make changes here; say "Your ads check now uses these
   numbers, so tomorrow's suggestions take this into account."
4. Update `rules/ads.json`: `target_roas` = total price ÷ total left-before-ads across these products, weighted by
   how much each sells (`units_30d` from `data/sales-speed/`), rounded **up** to the next 0.5. `target_roas_source` "profit". Say: "Your shop-wide ads target is
   now <n> (it was 4 as a starting point)."
5. Products with less than 10% margin: "This one barely makes money even without ads. Worth a price check, a
   bundle, or no ads on it." Don't change prices.

## Step 6 · Profit yesterday, every morning

1. Add `{"id": "profit-check", "name": "Profit check", …}` to `automations.json` and follow
   `automations/profit-check.md` steps 2 to 5 now (live chat, so a helper for step 2).
2. Show the card (EXAMPLE):
   ```
   YESTERDAY · 18 NOV
   ──────────────────────────────────
   Sales RM1,284 · 41 orders
   Shopee fees −RM334 · product costs −RM620 · packing −RM21 · running costs −RM103 · ads −RM38
   About RM168 profit (13%)
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
   Don't run it now: it gets its permission in Module 12, where one morning routine runs every check once
   together (and saves your allowance). Only if they must leave before Module 12: run it once now with
   `run_scheduled_task` and wait until it finishes before any helper uses the browser.

## Optional extras (2 minutes, skip if short on time)

Ready-made extras from `<HQ>/automations/extras.md`. They ride along with the profit check, so there's nothing new to
schedule or approve, and most cost almost no allowance. Read only that file's "How it works" and this module's part.

1. "Want any extras? They run with your profit check. Pick any, e.g. **A C**, or none."
   ```
   A) Products losing money  Mondays: which products lost money last week, and why
   B) Month-end report       the 1st of each month: last month on one page (and a Gmail draft if you like)
   C) Shopee fee check       the 1st of each month: tells you if Shopee changed its fees
   D) None for now ★
   E) Something else — tell me
   ```
2. Switch on each pick as "How it works" says (A = `loss-makers`, B = `month-report`, C = `fee-watch`). Ask only the setting a pick needs.
3. "Switched on. You can add or remove extras any time: just say **show my extras**."

## Step 7 · Close the module

1. "Press **Cmd+R** / **Ctrl+R** on your dashboard: **Profit yesterday** is live at the top, and Real profit shows
   which products make or lose money."
2. Update `<HQ>/CLAUDE.md`: "Where we are: Module 8 done · next: module9". One line under "The shop", e.g.
   "Shopee fees about 24.3% + RM0.54 (from real orders, 19 Nov) · running costs RM2.50 an order · ads target ROAS 5 from profit."
3. Say:
   - "Done: you know what you really keep, product by product, and every morning you'll see yesterday's profit."
   - Value line: "Most sellers only find out at month end, from the bank. You'll know every morning."
   - "Quick check: Settings → Usage. If the bar is past about 70%, tell me."
   - Gate: "That's 8 of 12 done. Next, campaigns: Shopee's big sale days, and how to join them without
     selling at a loss. Type **module9** when you're ready."

## If things go wrong

- **They don't know their costs:** "A rough guess is fine, we can fix it later." Or do only the 3 products they do
  know; the rest are estimated from those.
- **Fee % comes out odd** (under 10% or over 35%): one order may have had a refund, a shipping adjustment, an
  instalment payment or a campaign-day fee, or a voucher was counted as the shop's when Shopee paid it. Show the
  three orders' percentages, drop the odd one, or use the fee table and say why.
- **Sales on Business Insights don't match their own feeling:** Business Insights counts orders placed yesterday,
  including ones not yet shipped or paid out. "This is a daily estimate, not your bank statement."
- **A product makes a loss:** say it calmly and give one option ("raise the price a little, bundle it, or stop ads
  on it"). The decision is theirs. Never change a price.
- **SG shop:** Shopee SG charges the seller part of the shipping, by parcel weight (S$2.30 up to 1 kg, S$3.21 up
  to 5 kg); the buyer always pays S$1.99. Real orders show it. Use S$.
- **MY shop asks "why is the Service Fee so odd?":** it's two fees in one line: the Cashback fee plus RM0.54.
- **Big orders with several items:** the fee % still holds; only the RM0.54 (or SG shipping) is per order, so
  bigger baskets keep more per item.
