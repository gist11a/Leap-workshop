# Recipe: Full Shop Scan (once, in the background, with the owner's OK)

- **id:** `shop-scan` · **topic:** `scan` · **changes the shop:** never (read only). Not a scheduled job.
- **When:** Module 2 offers it (owner says YES first). Afterwards, any time they say **"scan my shop"** (once a month
  is plenty).
- **Why:** so Claude knows the shop from its real data (orders, ads, products, stock, reviews, past chats), not only
  from the interview. The interview still happens: the scan shows what the shop *does*, the questions say what the
  owner *wants*.
- **Saves:** `data/scan/<today>.json` (numbers) and `rules/shop-profile.md` (what Claude learned, in plain words).
- Replace `<HQ>` with the full Shopee HQ folder location, `<seller_centre>` and `<shop_name>` from `rules/shop.json`.

## How the boss runs it
Three helper trips, **one after another** (they share one browser), each a fresh helper so none gets too big for the
Claude allowance. Each: Agent tool, `model: "sonnet"`, `subagent_type: "general-purpose"`, prompt = the text of
`<HQ>/helpers/reader.md` + "Shop Scan part <n>" below. **Start it in the background** (if the Agent tool has a
`run_in_background` option, set it to true) and carry on talking with the owner. When you're told a part finished,
start the next part straight away, then carry on.

- **Nothing else uses the browser while the scan runs.** If a step needs the browser, say "My helper is finishing
  your shop scan. One minute," and wait for it to finish.
- A part replies `SIGNED_OUT` → stop the scan, ask the owner to sign in (Module 1 Step 6), then restart that part.
- A part fails or gets stuck → skip it, note "part <n> not read" in `rules/shop-profile.md`, go on.
- All three done → read `rules/shop-profile.md` (only that, not the day file), tell the owner what you learned
  (Module 2 says how), add `"shop-scan"` to `bonus` in `progress.json`, refresh.
- Every part: **read only, never type anything into a chat box, never press Reply, Send, Update, Delist, Edit or any
  switch.** No buyer names, phone numbers or addresses anywhere in the files: products, order numbers, numbers and
  patterns only.

## Shop Scan part 1 · Sales, orders, products and stock
> Seller Centre: `<seller_centre>`. Check "Current Shop" says `<shop_name>`; if not, stop and say `WRONG_SHOP`.
> Read each page with `get_page_text` (`max_chars` 6000 unless said otherwise).
> 1. **Business Insights** `/datacenter/overview`. Set the date to **Past 30 days** (date picker; OK is fine).
>    Collect `sales_30d`, `orders_30d`, `visitors_30d`, `conversion_30d` (percent as a number), `buyers_30d`,
>    `sales_per_order_30d`.
> 2. **My Orders** `/portal/sale/order`. Collect the count on each tab (`to_ship`, `shipping`, `cancellation`,
>    `return_refund`). From the first page (up to 20 orders) collect, per order: `products` (short names),
>    `items`, `total`, `courier`, `status`. Never open "Ship" or "Arrange Shipment". No buyer names.
> 3. **Product AI Optimiser** `/portal/product-ai-optimiser-v2` (products sorted by sales, with Item IDs). Collect
>    the top 15: `product` (first 60 characters), `item_id`, `sold` (as shown), `price`.
> 4. **The 5 best sellers, in detail:** open `/portal/product/<item id>` for each (wait 3 seconds; `max_chars`
>    8000). Collect `category`, `price_range`, `variations` (names, e.g. "250g, 500g · Whole bean, Ground"),
>    `weight`, `images` (how many), `has_video`, `description` (first 400 characters), and the key facts a buyer
>    would ask about (size, ingredients, expiry or shelf life, halal, origin, how to use) as `facts`. **Never press
>    Update, Delist or Save; don't change any field.**
> 5. **My Inventory** `/portal/inventory`. Collect `live_skus`, `shopee_out_of_stock`, `shopee_low_stock` from the
>    top, and the first 3 pages of rows (`product`, `stock`, `l30d_avg`, `days_of_supply`), reading as
>    `automations/stock-check.md` step 2 explains (names first, then 8 numbers per row).
> Save `<HQ>/data/scan/<today>.json`: `{"read_at", "source_pages", "summary": {the numbers above},
> "items": [top 15 products: product, price, sold, stock (if seen)], "orders_sample": [...], "best_sellers": [the
> 5 detailed products], "note": "one plain line"}`.
> Then write `<HQ>/rules/shop-profile.md` with these sections, short plain lines, at most 40 lines in all:
> `# What I learned about <shop_name> (shop scan, <today>)`, `## The shop in numbers (last 30 days)`,
> `## Best sellers`, `## Product facts` (one line per best seller: the facts a buyer asks about),
> `## Stock` (what's out or about to run out), `## Orders and delivery` (usual basket, couriers used, returns or
> cancellations that stand out).
> Reply in 5 lines: sales and orders for 30 days, the top 3 products, anything odd.

## Shop Scan part 2 · Ads, reviews and chat settings
> Seller Centre: `<seller_centre>`. Check "Current Shop" says `<shop_name>`.
> 1. **Shopee Ads** `/portal/marketing/pas/index`. Set the date to **Past 1 week**. Collect `ad_spend_7d`,
>    `ad_sales_7d`, `ad_roas_7d`, and the top 10 ads by spend: `ad` (name, first 50 characters), `spend`, `sales`,
>    `roas`, `status`. (Names come first in the text, then the numbers row by row.) Never touch a switch or budget.
> 2. **Review Management** `/portal/settings/shop/rating`. Collect `shop_rating`, the count for each star, and the
>    20 newest reviews: `stars`, `product` (short), `review` (first 100 characters), `replied` (true/false).
> 3. **Chat Management** `/portal/chat-management`. Collect `chat_enquiries_30d`, `chat_response_rate` (number),
>    `response_time` (as shown), and whether **Agent Greetings**, **Shortcut** and **FAQ** look switched on.
>    Don't open Edit.
> 4. **Shipping Channel** `/portal/all-settings/shipping/shipping-channel`. Collect `couriers_on` (names of the
>    channels switched on). **Never touch a switch.**
> Add these numbers to `"summary"` in `<HQ>/data/scan/<today>.json` (keep what part 1 saved) and add `"ads_top"`
> and `"reviews_sample"`. Also save `chat_enquiries_30d`, `chat_response_rate`, `response_time`, `couriers_on` and
> the three switches under `"summary"` in `<HQ>/data/shop/<today>.json`.
> In `<HQ>/rules/shop-profile.md` add: `## Ads` (spend, sales per RM1, the biggest spender, anything wasting money),
> `## Reviews` (rating, what buyers praise, what they complain about, how many bad reviews have no reply).
> Reply in 5 lines.

## Shop Scan part 3 · Past chats
> Seller Centre: `<seller_centre>`. Open `<seller_centre>/webchat/conversations`. Wait 5 seconds.
> - **Only open chats that are already read** (no unread number on them), so nothing new is marked as read for the
>   owner. Skip any chat from another shop (the chat list can mix shops). Never touch Serving Mode, never type in the
>   message box, never press Send.
> - Open up to **25** read chats, newest first (scroll the list if needed). For each, read the last messages with
>   `get_page_text` (`max_chars` 4000). Note for each: the topic of the buyer's question (one of: original/authentic,
>   delivery time, size or variant, stock, price or discount, how to use / expiry, return or refund, damaged or
>   wrong item, other) and, if the shop answered, how it answered (one line, no names).
> Then write, no buyer names or usernames anywhere:
> - in `"summary"` of `<HQ>/data/scan/<today>.json`: `chats_read`, `top_question_topics` (e.g.
>   `{"delivery time": 9, "halal": 5}`), `shop_answered_percent`;
> - in `<HQ>/rules/shop-profile.md`: `## What buyers ask most` (top 6 questions in the buyers' own words, shortened,
>   with how often), `## How the shop replies now` (language, tone, emoji or not, the greeting and sign-off it
>   usually uses, typical length), `## Answers the shop already gives` (up to 8 question → answer pairs, taken from
>   the shop's real replies, cleaned of names), `## Complaints in chat` (themes only).
> Reply in 5 lines: chats read, the top 3 questions, the shop's reply style.
