# Optional extras: ready-made automations the owner can switch on

Each extra **rides on a check they already have** (it runs at the end of that check, on the days it says), so it
needs no new schedule, no new "Always allow" and no fight over the browser. Most read nothing new: they work from the
files the check just saved, so they cost almost no Claude allowance.

Every extra follows the house rules: **read only, never changes the shop.** Anything that would change Shopee goes to
`approvals.json` for the owner's YES, or is a suggestion the owner does themselves in Seller Centre (money and price
buttons are always the owner's).

## How it works (for Claude)

**Switching one on** (in its module, or when the owner says "add an extra automation"):
1. Show the extras for that module as a lettered menu: name + one plain line + when it runs. Last two options:
   "None for now ★" and "Something else — tell me". They can pick several, e.g. **A C**.
2. For each pick: add its id to `"extras"` (a list) on the parent's entry in `automations.json` (the entry whose `id`
   is the extra's **rides on**), and ask the one setting it needs, if any (saved where the block says).
3. First extra of the day → add `"extra"` to `bonus` in `progress.json` (the Power User badge).
4. Say: "Switched on. It runs with your <parent name>, <days>. Nothing new to approve."
5. Don't run it now unless they ask ("try it now" → follow its block once, live, with today's files).
**Switching one off:** remove its id from `"extras"`. "show my extras" lists what's on and what's available.

**Running them (every check, before its "Finish" step):** if this automation's entry in `automations.json` has
`"extras"`, follow each listed block below **whose days match today** (shop's timezone), in the order listed. Then:
- Save what it found under `"extras": {"<extra id>": {"note": "one plain line", "items": [...]}}` in this check's day
  file (`data/<topic>/<today>.json`), keeping everything else in the file.
- Alerts use the parent check's `topic`. Before adding, remove this extra's alerts from earlier today (match the text
  start). At most 3 alerts per extra.
- If an extra fails, skip it, note it in the run's `result`, and finish the check as normal.

Allowance: **tiny** = reads no new pages · **small** = one page · **medium** = a few pages.

---

## Module 4 · Stock

### slow-movers · Slow movers
- **Rides on:** `stock-check` · **Days:** Mondays · **Reads:** nothing new · **Allowance:** tiny
- **Works out:** products with stock > 0 that sold nothing in 30 days: missing from the newest `data/sales-speed/`
  file, or `units_30d` 0 (never Shopee's rounded averages). Cash tied up = stock × cost, if `rules/costs.json` has the cost.
- **Tells the owner:** one `info` alert: "<n> products haven't sold in 30 days (about RM<cash> of stock). Ideas: a
  bundle, a campaign slot, or a shop voucher. Ask me for a plan." `items`: product, stock, cash_tied_up.

### stuck-out-of-stock · Out of stock too long
- **Rides on:** `stock-check` · **Days:** every day · **Reads:** nothing new · **Allowance:** tiny
- **Works out:** products at stock 0 in each of the last 7 stock day files (it hurts how Shopee shows the shop).
- **Tells the owner:** one `watch` alert: "<product> has been out of stock for 7+ days. Restock it, or delist it in
  My Products (you press the button)."

### order-by-date · Order-by dates
- **Rides on:** `stock-check` · **Days:** every day · **Reads:** nothing new · **Allowance:** tiny
- **Setting:** none new: it uses `supplier_lead_days` in `rules/stock.json` (a supplier's own `lead_days` wins). If
  they never said, ask once: "How many days from ordering to stock arriving?"
- **Works out:** for products with days left ≤ lead time + 3: the last safe day to order = today + (days left − lead
  time), never before today.
- **Tells the owner:** `urgent` if that day is today or past: "Order <product> today, or it runs out before new stock
  arrives." `watch` otherwise: "Order <product> by <weekday, date>."

## Module 6 · Chats and reviews

### faq-learner · New FAQ answers from this week's chats
- **Rides on:** `chat-review-check` · **Days:** Fridays · **Reads:** nothing new · **Allowance:** tiny
- **Works out:** this week's chat items in `approvals.json` (done, approved or hand-over) whose buyer question isn't
  covered by `rules/chat.json` → `faq`. Group the same question; keep ones asked 2+ times.
- **Saves:** for each (at most 3), an approval `{"id": "F<n>", "topic": "rules", "what": "Add to your FAQ: \"<q>\"",
  "before": null, "do": "<the answer, written from their rules>", "status": "waiting"}`. On YES, Claude adds it to
  `faq` (it changes the rules file only, nothing in Shopee).
- **Tells the owner:** `info`: "<n> new FAQ answers to check. Say 'what needs my YES?'."

### review-themes · What reviews are saying
- **Rides on:** `chat-review-check` · **Days:** Mondays · **Reads:** Review Management, last 7 days (one page) ·
  **Allowance:** small
- **Works out:** per product, what buyers praise and complain about (themes, not quotes). A complaint seen 3+ times is
  a pattern.
- **Tells the owner:** `info`: "Reviews this week: buyers love <theme>; <n> mention <complaint> on <product>." A
  pattern → `watch`: "<n> reviews say <product> <complaint>. Worth checking the stock or the listing photos."

### response-rate-guard · Chat response rate guard
- **Rides on:** `chat-review-check` · **Days:** every day (morning run only) · **Reads:** Chat Management (one page) ·
  **Allowance:** small
- **Setting:** lowest response rate they accept (default 90%), saved as `min_response_rate` in `rules/chat.json`.
- **Tells the owner:** `urgent` if the 30-day rate is below it: "Your chat response rate dropped to <r>%. Shopee
  shows this on your shop. Say 'what needs my YES?' to clear waiting chats."

## Module 7 · Ads

### ads-stock-guard · Don't advertise what you can't ship
- **Rides on:** `ads-check` · **Days:** every day · **Reads:** nothing new (today's ads + stock files) ·
  **Allowance:** tiny
- **Works out:** ads (still on) for products with stock 0 or under 3 days left in the latest stock file (match on
  the start of the name).
- **Saves:** for each, an approval to pause the ad (same shape as the ads check's pause suggestions).
- **Tells the owner:** `urgent`: "Your ad for <product> is still running but it's <out of stock / almost out>.
  Pause suggested; say 'what needs my YES?'."

### ads-winners · Ads that deserve more
- **Rides on:** `ads-check` · **Days:** Mondays · **Reads:** nothing new · **Allowance:** tiny
- **Works out:** ads whose 7-day sales per RM1 are at least 1.5 × `target_roas` in `rules/ads.json`, with 3+ orders.
- **Tells the owner:** `info` (a suggestion, never an approval: budgets are the owner's button): "<ad> made RM<x> for
  every RM1 last week. If you want more sales, raise its budget up to <max_change_percent>% in Shopee Ads."

### spend-spike · Spend spike alarm
- **Rides on:** `ads-check` · **Days:** every day · **Reads:** nothing new · **Allowance:** tiny
- **Works out:** yesterday's ad spend vs the average of the 7 days before (from the ads day files).
- **Tells the owner:** `watch` if yesterday was 50%+ higher and sales per RM1 fell: "Ads spent RM<y> yesterday, about
  <p>% more than usual, for fewer sales. Check the top spender: <ad>."

## Module 8 · Real profit

### loss-makers · Products losing money
- **Rides on:** `profit-check` · **Days:** Mondays · **Reads:** nothing new (last 7 profit files) · **Allowance:** tiny
- **Works out:** products whose profit per order was below zero on most of the last 7 days, and why (fees, ads,
  or the price below cost + fees).
- **Tells the owner:** `urgent` (at most 3): "<product> lost about RM<x> per order last week, mostly from <reason>.
  Options: raise the price, cut its ad, or stop discounting it. Ask me to work out a safe price."

### month-report · Month-end report
- **Rides on:** `profit-check` · **Days:** the 1st of each month · **Reads:** nothing new · **Allowance:** small
- **Works out:** last month from the day files kept (sales, profit, ad spend and sales per RM1, best and worst
  products, stock-outs, chats answered). Saves `data/reports/<YYYY-MM-01>.json` (`summary` + `note`).
- **Tells the owner:** `info`: "Your <month> report is ready: RM<sales> sales, about RM<profit> profit." If
  `morning_email` is on, also a Gmail **draft** "Shopee · <month> report". Never sent.

### fee-watch · Shopee fee check
- **Rides on:** `profit-check` · **Days:** the 1st of each month · **Reads:** 3 order detail pages ("See Income
  Details") · **Allowance:** medium
- **Works out:** the fees on 3 recent orders vs `rules/costs.json` (as in `course/modules/08-real-profit.md` Step 3).
- **Tells the owner:** `watch` if any rate moved by 0.5 points or more: "Shopee's <fee> looks like it changed from
  <a>% to <b>%. Say 'check my fees again' and I'll update your costs."

## Module 9 · Campaigns

### campaign-stock-cover · Enough stock for the campaign?
- **Rides on:** `campaign-check` · **Days:** every day, only when a campaign they joined or plan to join starts
  within 10 days · **Reads:** nothing new (campaign + stock files) · **Allowance:** tiny
- **Works out:** for its products: stock vs 3 × normal daily sales × campaign days (+ the days until it starts).
- **Tells the owner:** `watch`: "<campaign> starts <date>. <product> may run out: <stock> left, about <need> needed.
  Order more by <date>."

### campaign-results · How did the campaign do?
- **Rides on:** `campaign-check` · **Days:** the day after a campaign they joined ends · **Reads:** Business Insights
  for the campaign days (one page) · **Allowance:** small
- **Works out:** sales and orders on the campaign days vs the 7 days before; profit if the profit files cover it.
- **Saves:** one line in `rules/campaigns.json` → `learnings` (a list; add it if missing), e.g. "11.11: sales ×3,
  profit thin on Robusta". The campaign check reads it next time.
- **Tells the owner:** `info`: "<campaign>: RM<x> sales, <n>× a normal day. Next time: <one idea>."

## Module 10 · Affiliates

### sample-sorter · Sort sample requests
- **Rides on:** `affiliate-check` · **Days:** every day when `samples_to_approve` > 0 · **Reads:** the sample request
  list (one page) · **Allowance:** small
- **Setting:** none new: it uses `approve_samples_when` and `max_samples_per_week` in `rules/affiliates.json`
  (set in Module 10).
- **Works out:** each request vs those rules → "fits", "maybe" or "skip", with one reason.
- **Tells the owner:** `watch`: "<n> sample requests: <a> fit your rules (<names>). Approve them in Affiliate
  Marketing → Samples (you press the button)."

### star-affiliates · Thank your best affiliates
- **Rides on:** `affiliate-check` · **Days:** Mondays · **Reads:** nothing new · **Allowance:** tiny
- **Works out:** the top 3 affiliates by sales over the last 7 affiliate files.
- **Tells the owner:** `info`: "<affiliate> sold RM<x> for you last week. Ideas: a free sample of a new product, or a
  higher commission on your best seller (your margins allow up to <c>%)."

## Module 11 · Product images

### listing-health · Listing health check
- **Rides on:** `image-check` · **Days:** the 1st of each month · **Reads:** My Products list (up to 3 pages) ·
  **Allowance:** medium
- **Works out:** live products with fewer than 5 images, no video, or a title under 60 characters.
- **Tells the owner:** `info`: "<n> listings could look better: <x> with under 5 photos, <y> with no video. Start with
  <best seller>." `items`: product, images, video, title_length.

### new-product-check · New product check
- **Rides on:** `image-check` · **Days:** Mondays · **Reads:** My Products, newest first (one page) · **Allowance:** small
- **Works out:** products added in the last 7 days that have under 5 images or no selling points yet.
- **Tells the owner:** `watch`: "<product> is new and has only <n> photos. Say 'write my selling points' and I'll
  help."

## Module 12 · Daily routine

### weekly-review · Friday weekly review
- **Rides on:** `morning-routine` (morning run) · **Days:** Fridays · **Reads:** nothing new · **Allowance:** small
- **Works out:** the week from the day files: sales and profit vs last week, wasted ad money, stock to order, the best
  product, chats answered, and ONE thing to do next week.
- **Saves:** `data/reports/<today>.json` (`summary` + `note`).
- **Tells the owner:** adds a 6th line to the morning summary ("Week: RM<x> sales (+<p>%), …"), and if
  `morning_email` is on, a separate Gmail **draft** "Shopee · week of <date>". Never sent.

### monday-plan · Monday top three
- **Rides on:** `morning-routine` (morning run) · **Days:** Mondays · **Reads:** nothing new · **Allowance:** tiny
- **Works out:** from today's checks and open alerts, the three things that matter most this week, money first.
- **Tells the owner:** an `info` alert dated today: "This week: 1) <…> 2) <…> 3) <…>", and the same as the summary's
  last line.
