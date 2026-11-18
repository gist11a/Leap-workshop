# Automation recipe: Profit check (yesterday)

- **id:** `profit-check` · **topic:** `profit` · **changes the shop:** never (read only).
- **Saves:** `data/profit/<today>.json` (about yesterday), alerts, the run log.
- Runs **after** the ads check and the affiliate check, so yesterday's ad spend and commission are already saved.
- Replace `<HQ>` with the full Shopee HQ folder location (it's written in `<HQ>/CLAUDE.md`).

## 1. Get ready
Read `<HQ>/CLAUDE.md`, `rules/shop.json`, `rules/costs.json`, `tools/shopee-fees.json` (only the part for the
shop's market). "Today" = the date in the shop's timezone; "yesterday" = the day before.
If `costs.json` has no `fee_percent_normal` or no products, stop: log "skipped: costs not set up" and tell the owner.

## 2. Read yesterday's sales
**Who reads:** in a live chat with the owner (Opus), send ONE helper (Agent tool, `model: "sonnet"`,
`subagent_type: "general-purpose"`, prompt = the text of `<HQ>/helpers/reader.md` + the job below).
In a scheduled run you are already on Sonnet: read the page yourself, following every rule in `helpers/reader.md`.

The job:
> Open `<seller_centre>/datacenter/overview` (Business Insights). Wait 5 seconds. Check the shop is `<shop_name>`.
> Never press "Enable Now", "Export Data" or anything about Auto Top-up.
> Click **Data Period** (it says "Real-Time") and choose **Yesterday**. Wait 3 seconds.
> 1. From Key Metrics collect `sales` ("Sales", not the "Shopee Rebate applied" one), `orders`, `visitors`,
>    `conversion_rate` (Order Conversion Rate, a number), `sales_per_order`.
> 2. In **Top Performing Products** (ranked by Sales), collect up to 10 rows: `product` (first 60 characters),
>    `sales`, `units`, `orders`. Numbers come after the names, in the header's column order; match them in order.
> Save to `<HQ>/data/profit/<today>.json` as `{"read_at", "source_pages", "for_date": "<yesterday>",
> "summary": {…the numbers above}, "found": [...rows]}`. Reply with sales and orders only.

`SIGNED_OUT`: live chat → ask the owner to sign in; scheduled run → urgent alert "Seller Centre is signed out.
Please sign in in Claude's browser.", log "skipped: signed out", refresh, stop.

## 3. Work it out (you do this, not the helper)
1. **Was yesterday a campaign day?** Use `campaign_days` in `shopee-fees.json`: double dates (1.1, 2.2 … 12.12)
   count from 3 days before until the day; the 15th and the 25th count the day before and the day.
   If yes and `on_programme` is true, use `fee_percent_campaign`, else `fee_percent_normal`.
2. For each row in `found`, find the product in `costs.json` → `products` (match on the start of the name).
   - Matched: `fees` = sales × fee% + `fixed_fee_per_order` × orders. `cost_of_goods` = cost × units.
     `packaging` = (`packaging_per_order` + `other_cost_per_order`) × orders.
     `profit` = sales − fees − cost_of_goods − packaging. `margin_percent` = profit ÷ sales × 100.
   - Not matched: leave `profit` null for now.
3. **Average margin** = total profit ÷ total sales of the matched rows. Use it to estimate the unmatched rows and
   the sales not in the top 10 (`summary.sales` − the rows' sales). Add those to `estimated_sales`.
4. **Ads:** `ad_spend` = `summary.spend_yesterday` from `data/ads/<today>.json` if it exists, else 0 and say
   "ads not included". If `data/affiliates/<today>.json` exists, `affiliate_commission` = its `summary.commission_yesterday`, else 0.
5. Totals: `fees`, `cost_of_goods`, `packaging`, `ad_spend`, `profit` = all product profit (known + estimated)
   − ad_spend − affiliate_commission, `margin_percent` = profit ÷ sales × 100,
   `estimated_percent` = estimated_sales ÷ sales × 100. Round money to 2 decimals.

Write the day file again with `for_date`, `summary` (`sales`, `orders`, `visitors`, `conversion_rate`, `fees`,
`cost_of_goods`, `packaging`, `ad_spend`, `affiliate_commission`, `profit`, `margin_percent`, `estimated_percent`, `campaign_day`),
`items` (one per row: `product`, `units`, `sales`, `profit` (estimated ones marked in `note` only), `margin_percent`,
`status` = "Loss" if profit < 0, "Low" if margin < 10, else "Good") and a one-line `note`, e.g.
"Yesterday: RM1,284 sales, about RM221 profit (17%) after fees, costs and RM38 of ads."

## 4. Alerts
First remove alerts with `topic` "profit" dated today. Then add:
- `urgent` if `profit` < 0: "You lost about RM<−profit> yesterday. Biggest cost: <the largest of fees, product
  cost, ads>."
- `watch` for each product with status "Loss" (at most 3): "<product> lost money yesterday (RM<profit> on
  <units> sold)."
- `info` if `estimated_percent` > 30: "<n>% of yesterday's profit is estimated. Add costs for more products to make
  it exact."

## 5. Finish
1. Add to `data/runs/<today>.json`: `{"time", "automation": "Profit check", "result": "<note>", "alerts": <n>,
   "approvals": 0}`.
2. Update this automation's `last_run` and `last_result` in `automations.json`.
3. `bash "<HQ>/tools/refresh-dashboard.sh" "<HQ>"`.
4. Live chat: show it as in Module 7. Scheduled run: end with three lines, e.g.
   "Yesterday RM1,284 sales · about RM221 profit (17%) · Hazelnut 250g sold at a loss."
