# Automation recipe: Affiliate check

- **id:** `affiliate-check` · **topic:** `affiliates` · **changes the shop:** never. Claude suggests commission
  changes and which sample requests to approve; the owner does those in Shopee.
- **Saves:** `data/affiliates/<today>.json`, alerts, the run log.
- Runs **before** the profit check, so yesterday's commission is counted in profit.
- Replace `<HQ>` with the full Shopee HQ folder location (it's written in `<HQ>/CLAUDE.md`).

## 1. Get ready
Read `<HQ>/CLAUDE.md`, `rules/shop.json`, `rules/affiliates.json`, `rules/costs.json`. "Today" = the date in the
shop's timezone. **On Mondays** (and in the live module) also do the commission check in step 2C.

## 2. Read the affiliate pages
**Who reads:** in a live chat with the owner (Opus), send ONE helper (Agent tool, `model: "sonnet"`,
`subagent_type: "general-purpose"`, prompt = the text of `<HQ>/helpers/reader.md` + the job below).
In a scheduled run you are already on Sonnet: read the pages yourself, following every rule in `helpers/reader.md`.

The job:
> Never click Create, Promote Product, Set Sample, Remove, Batch Edit, Mass Upload, Approve, Reject, Ship or
> anything that changes the shop. You may click tabs and page numbers only.
> **A.** Open `<seller_centre>/portal/web-seller-affiliate/dashboard` (Key Analytics; it shows yesterday,
> "By Day"). Wait 5 seconds. Check the shop is `<shop_name>`. Collect `affiliate_sales_yesterday` (Sales),
> `affiliate_orders_yesterday` (Orders), `clicks_yesterday`, `commission_yesterday` (Est. Commission),
> `roi_yesterday` (ROI, null if "--"). From **Top Affiliates** collect up to 5 rows: `affiliate` (the name as
> shown), `sales`, `orders`, `commission`.
> **B.** Open `<seller_centre>/portal/web-seller-affiliate/homepage`. From **To Do List** collect
> `samples_to_approve` and `samples_to_ship`.
> **C. (Mondays / when asked)** Open `<seller_centre>/portal/web-seller-affiliate/open_campaign`. Read up to
> 3 pages of products: `product` (first 60 characters), `commission_percent`, `status` (Ongoing…).
> Save to `<HQ>/data/affiliates/<today>.json` as `{"read_at", "source_pages", "summary": {…A and B numbers},
> "top_affiliates": [...], "commissions": [...] (only if C was done)}`. Reply with yesterday's affiliate sales only.

`SIGNED_OUT`: live chat → ask the owner to sign in; scheduled run → urgent alert "Seller Centre is signed out.
Please sign in in Claude's browser.", log "skipped: signed out", refresh, stop.
**Shop not in the affiliate programme** (the pages say to join, or show nothing): save zeros, note it, and stop
after step 5 without alerts.

## 3. Work it out (you do this)
- `items` = `top_affiliates` (columns `affiliate`, `sales`, `orders`, `commission`).
- **Commission check** (only if `commissions` was read): for each product that has a `margin_percent` in
  `rules/costs.json` → `products` (match on the start of the name):
  - `after_commission` = margin_percent − commission_percent.
  - flag **"Loses money"** if after_commission < 0; **"Too high"** if it's below `keep_after_commission_percent`;
    **"Room to raise"** if after_commission > 25 and the product sells well (one of the 10 highest `l7d` in
    the latest `data/stock/` file's `all_products`);
    else **"OK"**.
  - Save to `rules/affiliates.json` → `commission.by_product`: `{"commission_percent", "margin_percent", "flag"}`.
- `note`: one plain line, e.g. "Affiliates sold RM37 yesterday (1 order), commission RM0. 2 sample requests waiting."

## 4. Alerts
First remove alerts with `topic` "affiliates" dated today. Then add:
- `urgent` for each product flagged "Loses money" (at most 3): "<product> pays affiliates <c>% but makes only
  <m>%. Every affiliate sale loses money. Lower the commission in Shopee → Affiliate Marketing → Open Campaign."
- `watch` if `samples_to_approve` > 0: "<n> sample requests waiting. Ask me which ones fit your rules."
- `info` for "Room to raise" (one alert for all): "<n> best sellers could pay affiliates more and still make
  money, to get more people promoting them."

## 5. Finish
1. Add to `data/runs/<today>.json`: `{"time", "automation": "Affiliate check", "result": "<note>", "alerts": <n>,
   "approvals": 0}`.
2. Update this automation's `last_run` and `last_result` in `automations.json`.
3. `bash "<HQ>/tools/refresh-dashboard.sh" "<HQ>"`.
4. Live chat: show it as in Module 9. Scheduled run: end with three lines, e.g.
   "Affiliates: RM37 yesterday, 1 order · 2 sample requests waiting · Hazelnut 250g commission too high."
