# Automation recipe: Ads check

- **id:** `ads-check` · **topic:** `ads` · **changes the shop:** never by itself. Suggested changes (pause an ad,
  change a budget) go into `approvals.json` and happen only after the owner's YES (`helpers/doer.md`).
- **Saves:** `data/ads/<today>.json`, approvals, alerts, the run log.
- Replace `<HQ>` with the full Shopee HQ folder location (it's written in `<HQ>/CLAUDE.md`).

## 1. Get ready
Read `<HQ>/CLAUDE.md`, `rules/shop.json`, `rules/ads.json`. "Today" = the date in the shop's timezone. Money is
in the shop's currency; save plain numbers.

## 2. Read Shopee Ads
**Who reads:** in a live chat with the owner (Opus), send ONE helper (Agent tool, `model: "sonnet"`,
`subagent_type: "general-purpose"`, prompt = the text of `<HQ>/helpers/reader.md` + the job below).
In a scheduled run you are already on Sonnet: read the page yourself, following every rule in `helpers/reader.md`.

The job:
> Open `<seller_centre>/portal/marketing/pas/index`. Wait 5 seconds. Check "Current Shop" is `<shop_name>`.
> **This page is full of buttons that spend money or change settings: Join Now, Top Up, Enable Auto Top-Up,
> Apply Setting, Activate Now, Create Now, Adopt Now, Add Products, Rapid Boost, any switch. Never press them.**
> The only things you may click: the date box next to **Performance**, the tabs (Product Ads, Shop GMV Max,
> Ad Group & Individual Ads) and page numbers.
> 1. Collect `ads_credit` ("Ads Credit").
> 2. Click the date box next to Performance (it says "Today"), choose **Yesterday**. Collect `spend_yesterday`
>    ("Expense"), `sales_yesterday` ("Sales"), `orders_yesterday`, `roas_yesterday`.
> 3. Choose **Past 1 week**. Collect `spend_7d`, `sales_7d`, `orders_7d`, `roas_7d`.
> 4. Still on Past 1 week, read the ads list under **Product Ads List**: the **Shop GMV Max** tab (if there is one)
>    and the **Ad Group & Individual Ads** tab, up to 30 rows in total, using `get_page_text` (`max_chars` 9000).
>    The text comes out as **all ad or product names first, then the numbers row by row**, in the column order of
>    the header (Impressions, Clicks, CTR, Expense, Sales, Conversions, Items Sold, ROAS, …). **Each number is
>    followed by its % change: skip the % changes.** Match rows to names in order; the counts must be equal.
>    For each row keep `ad` (first 60 characters of the name), `where` ("Shop GMV Max" or "Ad Group"),
>    `spend` (Expense), `sales`, `orders` (Conversions), `roas`, and `status` if one is shown (Ongoing, Paused…).
> Save to `<HQ>/data/ads/<today>.json` as `{"read_at", "source_pages", "summary": {…the numbers above},
> "found": [...rows]}`. Reply with the row count and the 7-day ROAS only.

`SIGNED_OUT`: live chat → ask the owner to sign in; scheduled run → urgent alert "Seller Centre is signed out.
Please sign in in Claude's browser.", log the run as "skipped: signed out", refresh, stop.

## 3. Work it out (you do this, not the helper)
With `rules/ads.json` (if `target_roas` is empty, use 4 and say so). If an ad's name matches a product in
`rules/costs.json` that has a `break_even_roas`, use that product's number instead of `target_roas` for that ad:
- **wasted**: a row with `spend` > `wasted_spend.spend_over` and `orders` = 0 in the last 7 days.
- **below target**: `orders` > 0 and `roas` < `target_roas`.
- **great**: `roas` ≥ 1.5 × `target_roas` with at least 3 orders.
- otherwise **OK**.
- `wasted_spend_7d` = total spend of the wasted rows. `credit_days_left` = `ads_credit` ÷ (`spend_7d` ÷ 7),
  one decimal (null if no spend).

Write the day file again with `summary` (all the numbers from step 2 plus `wasted_spend_7d`, `credit_days_left`,
`target_roas`), `items` (every row: `ad`, `spend`, `sales`, `orders`, `roas`, `flag` = "No orders" / "Below target"
/ "Great" / "OK", sorted No orders → Below target → Great → OK, then by spend), and a one-line `note`, e.g.
"RM212 spent last week at ROAS 4.4. RM31 went to 2 ads with no orders."

## 4. Suggestions (go to `approvals.json`, never done without a YES)
Skip anything in `never_touch`, anything in the **Shop GMV Max** group (Shopee manages those products itself), and
anything that already has a `waiting` ads suggestion. At most 3 suggestions per run:
- Each **wasted** ad → `{"id": "A<n>", "created", "topic": "ads", "what": "Pause '<ad>' (RM<spend> spent in 7 days,
  no orders)", "where": {"page": "/portal/marketing/pas/index", "ad": "<ad>"}, "before": "Ongoing, RM<spend>
  spent, 0 orders", "do": "Pause the ad '<ad>'", "kind": "pause", "status": "waiting"}`.
- **Great** ads that ran out of budget (the page said "budget limit reached" for them) → raise the daily budget
  by at most `max_change_percent`: `"do": "Change the daily budget of '<ad>' from RM<x> to RM<y>"`, `kind` "budget".
  Only suggest this if `credit_days_left` is 3 or more.
Never suggest Top Up, Auto Top-Up, Join, Boost or any new ad.

## 5. Alerts
First remove alerts with `topic` "ads" dated today. Then add:
- `urgent` if `credit_days_left` < `low_credit_days`: "Ads credit runs out in about <n> days (RM<credit> left).
  Top up in Shopee Ads if you want ads to keep running." (Topping up is the owner's job, never Claude's.)
- `watch` for wasted spend: "RM<wasted_spend_7d> spent last week on <n> ads with no orders."
- `watch` if `roas_7d` < `target_roas`: "Ads made RM<roas_7d> per RM1 last week, below your target of <target>."
- `info` if there are suggestions: "<n> ad changes ready for your YES."

## 6. Finish
1. Add to `data/runs/<today>.json`: `{"time", "automation": "Ads check", "result": "<note>", "alerts": <n>,
   "approvals": <suggestions added>}`.
2. Update this automation's `last_run` and `last_result` in `automations.json`.
3. `bash "<HQ>/tools/refresh-dashboard.sh" "<HQ>"`.
4. Live chat: show it as in Module 6. Scheduled run: end with three lines, e.g.
   "Yesterday RM38 spent, ROAS 4.9 · 7 days ROAS 4.4 · 2 ads wasted RM31 (pause suggested)."
