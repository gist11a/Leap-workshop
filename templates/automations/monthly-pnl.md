# Recipe: Monthly true P&L (once a month, with the owner)

- **id:** `monthly-pnl` · **topic:** `finance` · **changes the shop:** never (read only). Not a scheduled job: Shopee
  asks for the login password every time Finance is opened, and only the owner types it.
- **When:** Module 8 offers it. Afterwards, any time they say **"do my monthly P&L"** (best after the 5th, when last
  month's statement and tax invoices are all in).
- **Why:** the daily profit is an estimate. The monthly Income Statement is what Shopee actually paid, so **when the
  two disagree, trust the month.**
- **Saves:** `data/finance/<today>.json` (shown on the dashboard for 30 days) and a copy `data/finance/pnl-<YYYY-MM>.json`
  (kept, so month-on-month stays possible). **Never** copy bank details, buyer names or addresses into any file.
- Shopee know-how: `<HQ>/knowledge/shopee-basics.md` §6 and §6b.

## 1. The owner downloads the statement
Say: "Shopee keeps the real monthly numbers in a statement you download. Shopee will ask for your password: please
type it yourself."
1. "In Seller Centre: **Finance → My Income → Income Statements**, pick **Monthly**, and **Download** <month>. Then
   tell me where it saved (usually your Downloads folder)."
2. Open the PDF (Claude can read PDFs directly) and take each line **exactly as printed**. Never re-work Shopee's
   lines from rates. Lines usually include: product price, refunds, seller vouchers, shipping lines (buyer paid,
   Shopee rebate, logistics, return shipping), commission, service fee, transaction fee, campaign fee, AMS
   (affiliates), total payout released, and **order adjustments**.
3. Check it adds up: the lines above "total payout released" must make that total. If they don't, say so and stop.

## 2. Optional extras, read on screen (the owner types the password)
Only if they want to go further. Send ONE helper (Agent tool, `model: "sonnet"`, `subagent_type: "general-purpose"`,
prompt = `<HQ>/helpers/reader.md` + this job):
> In `<seller_centre>`, **Finance → My Balance → Recent Transactions**, tab **Adjustment**, for <month>: collect each
> row's type and amount (no names). Then **Finance → My Income → My Tax Invoices**: the totals of each invoice for
> <month> (Shopee, SPX, SVS, Affiliate, Credit Notes). If Shopee asks for a password, stop and reply `PASSWORD`.
> Never press Withdraw, Top Up, Pay or anything that moves money. Save to the finance file under `"balance"` and
> `"invoices"`. Reply with the totals only.
`PASSWORD` → ask the owner to type it in Claude's browser, then send the helper again.

## 3. Add the shop's own costs
- **Ads:** the month's ad **spend** (Shopee Ads → that month → Expense). The SVS tax invoice is ad credit
  *bought*, which can differ from what was spent in any one month; show it only as a side note.
- **Product cost:** units sold × cost per unit from `rules/costs.json` (units from the statement export if they have
  it, else the month's Business Insights units). Products with no cost: use the average margin and mark "estimated".
- **Packing / warehouse:** orders × (`packaging_per_order` + `other_cost_per_order`), or the warehouse's real invoice
  if they have it (better: it includes storage and minimums).
- **Running costs:** `monthly_fixed_costs` if set.

## 4. Work it out
```
  Product price
− Refunds − Seller vouchers                = Net sales
± Shipping subtotal (buyer paid + Shopee rebate − logistics − return shipping)
− Commission − Service fee − Transaction fee − Campaign fee − AMS
= Total payout released                    ← Shopee's own total
− Order adjustments                        ← printed on the statement but NOT inside its payout total
± Credit notes (only if not already in the statement; if unsure, leave out and say so)
− Ads spend − Product cost − Packing / warehouse − Running costs
= Net profit  (and % of net sales)
```
Rules learned the hard way:
- **Adjustments count once.** They sit outside the payout total. The Returns QC fees in My Balance are usually the
  same money as the statement's adjustment line: don't subtract both.
- **The statement goes by payout release date, not order date.** Late orders from last month show up in this one.
- **Cancelled orders are never paid out**, so they need nothing.
- Also save the month's **voucher share** (seller vouchers ÷ product price) and **affiliate share** (AMS ÷ net sales)
  in `rules/costs.json` → `settings` as `voucher_percent` and `affiliate_percent`: Module 8's realistic break-even
  uses them.
- SG: withdrawals are free once a week, then S$0.20 each; add them if the owner withdraws often.

Save `{"read_at", "for_month": "<YYYY-MM>", "source_pages": ["Income Statement PDF", …], "summary": {"net_sales",
"shopee_fees", "affiliates", "payout", "adjustments", "ad_spend", "product_cost", "packing", "running_costs",
"net_profit", "margin_percent", "estimated_percent"}, "items": [one per line: {"line", "amount", "basis"}],
"note"}` to both files, then `bash "<HQ>/tools/refresh-dashboard.sh" "<HQ>"`.

## 5. Show it
```
<MONTH> · YOUR TRUE MONTH
──────────────────────────────────
Net sales RM18,400 (after refunds and your vouchers)
Shopee fees −RM4,420 · affiliates −RM550 → Shopee paid you RM13,430
Adjustments −RM60 · ads −RM3,300 · product costs −RM6,900 · packing −RM640
About RM2,530 net profit (14% of net sales), before running costs
```
(EXAMPLE numbers.) Then one plain lesson, picked from their numbers: the biggest cost after products (often ads:
"every +0.5 on your ROAS is worth about RM<x> a month at this spend"), or how far the daily estimates were off
("your daily checks said about RM<y>; the statement says RM<z>, so I'll trust the month").
