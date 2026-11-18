# Automation recipe: Morning stock check

- **id:** `stock-check` · **topic:** `stock` · **changes the shop:** never (read only)
- **Saves:** `data/stock/<today>.json`, alerts, the run log. Then refreshes the dashboard.
- Replace `<HQ>` with the full Shopee HQ folder location (it's written in `<HQ>/CLAUDE.md`).

## 1. Get ready
Read `<HQ>/CLAUDE.md`, `<HQ>/rules/shop.json` and `<HQ>/rules/stock.json`. "Today" is the date in the shop's
timezone, written `YYYY-MM-DD`.

## 2. Read My Inventory
**Who reads:** in a live chat with the owner (Opus), send ONE helper: Agent tool, `model: "sonnet"`,
`subagent_type: "general-purpose"`, prompt = the text of `<HQ>/helpers/reader.md` + the job below.
In a scheduled run you are already on Sonnet: read the page yourself and follow every rule in
`<HQ>/helpers/reader.md`.

The job:
> Open `<seller_centre>/portal/inventory` (it opens the **Live** tab). Wait 3 seconds. Check "Current Shop" is
> `<shop_name>`; if not, stop and say `WRONG_SHOP`.
> 1. From the dashboard at the top, collect `live_skus` ("Live SKUs"), `shopee_out_of_stock` ("SKUs Out of
>    Stock") and `shopee_low_stock` ("SKUs with Low Stock").
> 2. Read the table on every page (page numbers at the bottom; at most 20 pages). Read each page with
>    `get_page_text` (`max_chars` 8000). The text comes out as **all product names first** (each with its
>    "Combo:", "Parent SKU:" and "SKU:" lines), **then the numbers, 8 per row**, in this order:
>    L7D Sales Average, L30D Sales Average, Days of Supply, Location, Stock, Reserved Stock,
>    Minimum Stock Threshold, Supplier Lead Time. Match them to the names in order. The number of rows of
>    numbers must equal the number of names; if not, read that page again.
> 3. For every row keep: `product` (first 60 characters of the name), `variation` (the "Combo:" text, or null),
>    `sku`, `l7d`, `l30d`, `days_of_supply` ("-" = null), `stock`.
> Never touch the On-demand switches, the Restock Alert switch, Edit, Mass Update, Restock Now or Export.
> Save into `<HQ>/data/stock/<today>.json` as `{"read_at", "source_pages", "summary": {"live_skus",
> "shopee_out_of_stock", "shopee_low_stock"}, "all_products": [...rows]}`. Reply with the row count only.

If the helper says `SIGNED_OUT`: in a live chat ask the owner to sign in (CLAUDE.md); in a scheduled run, write
an urgent alert "Seller Centre is signed out. Please sign in in Claude's browser.", log the run as
"skipped: signed out", and stop.

## 3. Work it out (you do this, not the helper)
Use `rules/stock.json`. Skip anything in `ignore_products`. For each row:
- **sold_per_day** = `l7d`, or `l30d` if `l7d` is 0. One decimal place.
- **days_left** = `days_of_supply` if Shopee gave one, else `stock ÷ sold_per_day` (one decimal).
  If sold_per_day is 0, the product isn't selling: skip it (unless it's a hero product).
- **lead_days** = that product's supplier `lead_days` from `suppliers`, else `supplier_lead_days`.
- **status:**
  - `Out of stock`: stock is 0 and sold_per_day > 0.
  - `Order now`: days_left ≤ lead_days (it runs out before new stock can arrive).
  - `Order soon`: days_left < `alert_when_days_left_below`.
  - otherwise fine.
- **reorder_qty** (only for the three statuses above) = round up `sold_per_day × (reorder_to_cover_days +
  lead_days)` − stock, never below 0.
  Example: sells 4.2 a day, cover 30, lead 7 → 4.2 × 37 = 155.4 → 156, minus 12 in stock = **144**.

Write the day file again with:
- `summary`: `low_stock` (Order now + Order soon), `out_of_stock` (Out of stock), `order_now`
  (Out of stock + Order now), `products_checked`, plus the three numbers from step 2.
- `items`: every flagged product, plus every hero product whatever its status (status "Fine" if fine), sorted
  Out of stock → Order now → Order soon → Fine, then by days_left. Each item: `product` (add the variation in
  brackets if there is one), `stock`, `sold_per_day`, `days_left`, `reorder_qty`, `status`.
- `note`: one plain line, e.g. "4 products to order today, 3 more this week."
- Keep `all_products` as it was.

## 4. Alerts
In `alerts.json`, first remove alerts with `topic` "stock" dated today (so a second run doesn't repeat them). Then add,
newest first:
- `urgent`, one per Out of stock / Order now product (at most 5; if more, a sixth: "and N more to order today"):
  "<product>: <stock> left, about <days_left> days. Order <reorder_qty>." (Out of stock: "<product> is out of
  stock and sells about <sold_per_day> a day. Order <reorder_qty>.")
- `watch`, one line for all Order soon products: "<N> products to order this week: <first three names>…"
- Hero products that are Order soon count as `urgent`.
Keep the newest 50 alerts.

## 5. Finish (every job ends this way)
1. Add to `data/runs/<today>.json` (a list): `{"time": "<today> HH:MM", "automation": "Morning stock check",
   "result": "<the note>", "alerts": <number added>, "approvals": 0}`.
2. In `automations.json`, set this automation's `last_run` and `last_result` (the note).
3. Run `bash "<HQ>/tools/refresh-dashboard.sh" "<HQ>"`.
4. **Live chat:** tell the owner the result in the style in `rules/shop.json` → `how_to_talk_to_me`.
   **Scheduled run:** finish with that same short summary as your last message.
